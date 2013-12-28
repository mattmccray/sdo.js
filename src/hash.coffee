
setPair= (atts, key, value, _silent, _changed)->
  if value isnt atts[key]
    oldValue= atts[key]
    oldValue?.onChange?(_changed, false)
    atts[key]= value
    _changed([key]) unless _silent
    value?.onChange?(_changed)
    yes
  else
    no

setObject= (atts, hash, _silent, _changed)->
  keys= []
  for own key,value of hash
    keys.push(key) if setPair atts, key, value, yes, _changed
  if keys.length > 0
    _changed(keys) unless _silent
    yes
  else
    no

Hash= (source, callback)->
  _atts= {} #extend {}, source
  _listeners= null
  _changed= (keys)->
    return null unless _listeners and _listeners.length > 0
    callback(keys, hash) for callback in _listeners

  hash=

    set: (key, value, _silent)->
      if arguments.length is 2
        setPair _atts, key, value, _silent, _changed
      else
        setObject _atts, key, _silent, _changed

    get: (key)->
      if arguments.length is 1
        _atts[key]
      else
        atts={}
        for key,value of _atts
          atts[key]= value?.get?() or value
        atts

    onChange: (fn, remove)->
      _listeners= [] unless _listeners?
      if remove
        _listeners= (cb for cb in _listeners when cb isnt fn) #excise fn, _listeners
      else
        unless fn in _listeners
          _listeners.push fn

  hash.onChange(callback) if callback
  hash.onChange.clear= -> _listeners= []
  hash.set(source) if source
  hash


((root)-> root.Hash = Hash)(module?.exports or this)


