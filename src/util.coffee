
_slice= Array::slice
_toString= Object::toString

Object.create or Object.create= do ->
  F= ->
  (o)->
    F:: = o
    return new F()

type= do ->
  elemParser= /\[object HTML(.*)\]/
  classToType= {}
  for name in "Array Boolean Date Function NodeList Null Number RegExp String Undefined ".split(" ")
    classToType["[object " + name + "]"] = name.toLowerCase()
  (obj) ->
    strType = _toString.call(obj)
    # strType = String(obj)
    if found= classToType[strType]
      found
    else if found= strType.match(elemParser)
      found[1].toLowerCase()
    else
      "object"

extend= (obj)->
  for source in _slice.call(arguments, 1)
    if source
      for key,value of source
        obj[key]= value
  obj

excise= (item, list)->
  (listitem for listitem in list when listitem isnt item)

uid= do ->
  last=0
  radix=36
  ->
    now= (new Date).getTime()
    now += 1 while now <= last
    last= now
    now.toString(radix)

# uid= (radix=36)->
#   now= (new Date).getTime()
#   while now <= uid._prev or 0
#     now += 1
#   uid._prev= now
#   now.toString radix

OnChangeImpl=
  onChange: (cb, listen=true)->
    @_listeners or= []
    if listen
      unless cb in @_listeners
        @_listeners.push cb
    else
      @_listeners= (fn for fn in @_listeners when fn isnt cb)
    this

  _changed: (params...)->
    return this unless @_listeners? and @_listeners.length > 0
    callback(params...) for callback in @_listeners
    this

  dispose: ->
    return this unless @_listeners?
    @_listeners.length= 0


((root)-> 
  root.uid= uid
  root.type= type
)(module?.exports or this)

# if module?
#   module.exports.type= type
#   module.exports.uid= uid
# else
#   @type= type
#   @uid= uid
