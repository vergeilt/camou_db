const fs = require("fs");
const initSqlJs = require("./wasm/sql-wasm.js");

const DB_PATH = "./resources/camou_db/db.sqlite";
const WARN_TIME = 120;
const VERBOSE = true;

const log = (...args) => VERBOSE && console.log(...args);

async function main() {
    const SQL = await initSqlJs();
    const db = new SQL.Database(fs.readFileSync(DB_PATH));

    const saveDb = () => {
        log("Saving database");
        fs.writeFileSync(DB_PATH, Buffer.from(db.export()));
    };

    const execute = (query, params = {}) => {
        log("Executing:", query, params);
        const start = Date.now();
        db.run(query, params);
        const duration = Date.now() - start;
        if (duration > WARN_TIME) log(`Execution took ${duration}ms`);
        saveDb();
    };

    const select = (table, columns, where = {}, rawWhere = false) => {
        const whereClause = rawWhere || Object.keys(where).map(k => `${k} = :${k}`).join(" AND ");
        const params = rawWhere ? {} : Object.fromEntries(Object.entries(where).map(([k, v]) => [":" + k, v]));
        const query = `SELECT ${columns.join(",")} FROM ${table} WHERE ${whereClause}`;
        log("Executing:", query, params);
        return db.exec(query, params);
    };

    on("camou_db:s:execute", (query, params) => execute(query, params));
    on("camou_db:s:select", (callbackId, table, columns, where, rawWhere) => {
        emit("camou_db:s:callbackResult", callbackId, select(table, columns, where, rawWhere));
    });
    on("onResourceStop", saveDb);

    emit("camou_db:s:dbReady");
}

main().catch(console.error);