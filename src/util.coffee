
_global= this
_slice= Array::slice
_toString= Object::toString

type= do ->
  elemParser= /\[object HTML(.*)\]/
  classToType= {}
  for name in "Array Boolean Date Function NodeList Null Number RegExp String Undefined ".split(" ")
    classToType["[object " + name + "]"] = name.toLowerCase()
  (obj) ->
    strType = _toString.call(obj)
    if found= classToType[strType]
      found
    else if found= strType.match(elemParser)
      found[1].toLowerCase()
    else
      "object"

uid= do ->
  last=0
  radix=36
  ->
    now= (new Date).getTime()
    now += 1 while now <= last
    last= now
    now.toString(radix)

expose= do ->
  _root = (module?.exports) or _global
  (ctx)->
    for own key,value of ctx
      throw new Error "#{key} already exists!" if key in _root
      _root[key]= value


class OnChange
  # If fn is null and remove is true, it'll clear all listeners.
  onChange: (fn, remove)->
    @_listeners= [] unless @_listeners?
    if remove
      if fn?
        @_listeners= (cb for cb in @_listeners when cb isnt fn)
      else
        @_listeners= []
    else
      unless fn in @_listeners
        @_listeners.push fn
  
  _notifyChange: (data)=>
    return null unless @_listeners and @_listeners.length > 0
    callback(data, this) for callback in @_listeners


expose {
  uid
  type
}
