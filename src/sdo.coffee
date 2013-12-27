# Hash and List

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

uid= (radix=36)->
  now= (new Date).getTime()
  while now <= uid._prev or 0
    now += 1
  uid._prev= now
  now.toString radix

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

HashImpl= extend {}, OnChangeImpl,
  type: 'hash'
  isHash: true
  isList: false

  setPair: (key, value, _silent)->
    if value isnt @_atts[key]
      oldValue= @_atts[key]
      oldValue?.onChange?(@_changed, false)
      @_atts[key]= value
      @_changed([key], this) unless _silent
      value?.onChange?(@_changed)
      yes
    else
      no

  set: (keyOrValues, value, _silent)->
    if type(keyOrValues) is 'string'
      @setPair keyOrValues, value, _silent
    else
      keys= []
      for own k,v of keyOrValues
        keys.push(k) if @setPair k, v, yes
      if keys.length > 0
        @_changed(keys, this) unless _silent
        yes
      else
        no

  get: (key)->
    if arguments.length is 0
      atts={}
      for key,value of @_atts
        atts[key]= value?.get?() or value
      atts
    else
      @_atts[key]

  remove: (key, _silent)->
    if _hasOwn.call(@_atts, key)
      val= @_atts[key]
      val.onChange?(@_changed, false)
      delete @_atts[key]
      @_changed([key], this) unless _silent
      val
    else
      null

  toString: -> "[object Hash]"

Hash= (base={}, callback)->
  hash= Object.create(HashImpl)
  hash._atts= {}
  hash.set(base, null, true)
  hash.onChange(callback) if callback?
  hash._changed= hash._changed.bind(hash)
  hash


ListImpl= extend {}, OnChangeImpl,
  type: 'list'
  isHash: false
  isList: true

  add: (value, _silent)->
    unless value in @_list
      @_list.push value
      value?.onChange? @_changed
      @length= @_list.length
      @_changed('add', this, value) unless _silent
    this

  addAll: (values, _silent)->
    for value in values
      @add value, _silent
    this
  
  remove: (value, _silent)->
    # @_list= arrayWithout @_list, model
    @_list= (val for val in @_list when val isnt value)
    value?.onChange? @_changed, true
    @length= @_list.length
    @_changed('remove', this, value) unless _silent
    this

  get: (index) -> 
    if arguments.length is 0
      (val?.get?() or val for val in @_list)
    else
     @_list[index]

  items: -> 
    @_list

  toString: -> "[object List]"

List= (base=[], callback)->
  list= Object.create(ListImpl)
  list._list=[]
  list.addAll(base, true)
  list.onChange(callback) if callback?
  list._changed= list._changed.bind(list)
  list


if module?
  module.exports.Hash= Hash
  module.exports.List= List
  module.exports.type= type
  module.exports.uid= uid
else
  @Hash= Hash
  @List= List
  @type= type
  @uid= uid
  # if @type?
  #   @originalType= @type
  #   console?.warn?("Old window.type has been replaced. You can access the previous version at window.originalType")
    

