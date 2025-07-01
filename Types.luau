--!strict
export type Table = {[any] : any}
export type Array<T> = {[number] : T}
export type Function = (...any) -> ...any
export type Iterator = (state: any, current: any) -> (any, any)
export type Callback<Args..., Rets...> = { f: (Args...) -> Rets... }
export type Metatable = {
	__index : ((self : Table, index : any) -> any) | Table,
	__newindex : (self : Table, index : any, value : any) -> nil,
	__call : (self : Table, ...any) -> ...any,
	__concat : (self : Table, value : any) -> any,
	__unm : (self : Table) -> any,
	__add : (self : Table, value : any) -> any,
	__sub : (self : Table, value : any) -> any,
	__mul : (self : Table, value : any) -> any,
	__div : (self : Table, value : any) -> any,
	__idiv : (self : Table, value : any) -> any,
	__mod : (self : Table, value : any) -> any,
	__pow : (self : Table, value : any) -> any,
	__tostring : (self : Table) -> string,
	__metatable : any,
	__eq : (self : Table, value : any) -> boolean,
	__lt : (self : Table, value : any) -> boolean,
	__le : (self : Table, value : any) -> boolean,
	__mode : "k" | "v" | "kv",
	__len : (self : Table) -> number,
	__iter : (self : Table) -> (Iterator, any, any),
}

export type Structure = {[string] : any}
export type Interface = {[string] : Function}

export type Class<Interface, Parent> = typeof(setmetatable({} :: Interface, {__index = {} :: Parent}))
	-- __call : (Structure) -> Instance<Structure, Class<Structure, Interface, Parent>>
export type Instance<Structure, Class> = typeof(setmetatable({} :: Structure, {__index = {} :: Class}))



export type Event = Instance<{}, Class<{
	fire : (self : any, ...any) -> (),
	connect : (self : any, Function) -> (Connection),
	wait : (self : any) -> ...any,
	once : (self : any, Function) -> (Connection),
}, Object>>
-- export type Connection = Instance<{}, Class<{disconnect : (self : any) -> ()}, Object>>
-- export type DeclarativeInstance<T, Children> = (T, Children) -> T & Children

return nil
