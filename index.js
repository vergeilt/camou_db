import Database from 'better-sqlite3'

const convars = {}
convars.path = GetConvar('db_path', '')

const db = new Database(convars.path)
db.pragma('journal_mode = WAL')

exports('create', async (query, cb) => {
    const stmt = db.prepare(query)
    const info = stmt.run(values)
    
    console.log(info.changes)
    return cb
})