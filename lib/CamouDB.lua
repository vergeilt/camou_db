local CamouDB = {}
local camoudb = exports.camou_db

setmetatable(CamouDB, {
    __index = function(self, method)
        self[method] = setmetatable({}, {
            __call = function(...)
                return camoudb[method](...)
            end,
            __index = function(_, key)
                if (method == "Async") then
                    return function(params, callback)
                        camoudb[method](key, params, callback)
                    end
                end
            end
        })
        return self[method]
    end
})

_ENV.CamouDB = CamouDB