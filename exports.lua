local callbacks, nextCallbackId = {}, 0

local function trigger(event, ...)
    TriggerEvent("camou_db:s:" .. event, ...)
end

local function getCallbackId()
    nextCallbackId = nextCallbackId + 1
    return tostring(nextCallbackId)
end

local function formatResponse(response)
    if not response[1] then return nil end
    local formatted = {}
    for _, values in ipairs(response[1].values) do
        local row = {}
        for i, column in ipairs(response[1].columns) do
            row[column] = values[i]
        end
        table.insert(formatted, row)
    end
    return formatted
end

local function selectFromDb(table, columns, where, rawWhere)
    local resultPromise, callbackId = promise:new(), getCallbackId()
    callbacks[callbackId] = function(response)
        resultPromise:resolve(response)
        callbacks[callbackId] = nil
    end
    trigger("select", callbackId, table, columns, where, rawWhere)
    return formatResponse(Citizen.Await(resultPromise))
end

AddEventHandler("camou_db:s:callbackResult", function(callbackId, response)
    if callbacks[callbackId] then callbacks[callbackId](response) end
end)

exports("createTable", function(...) trigger("createTable", ...) end)
exports("insert", function(...) trigger("insert", ...) end)
exports("update", function(...) trigger("update", ...) end)
exports("delete", function(...) trigger("delete", ...) end)
exports("executeRawWithParams", function(...) trigger("executeRawWithParams", ...) end)
exports("executeRaw", function(...) trigger("executeRaw", ...) end)
exports("select", selectFromDb)