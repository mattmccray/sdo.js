
List= (source, callback)->
  _list= [] #extend {}, source
  _listeners= null
  _changed= (action)->
    return null unless _listeners and _listeners.length > 0
    callback(action, list) for callback in _listeners

  list=
    length: 0

    add: (value, _silent)->
      # unless value in _list
      _list.push value
      value?.onChange?(_changed)
      @length= _list.length
      _changed('add') unless _silent
      this

    addAll: (values, _silent)->
      for value in values
        @add value, _silent
      this
    
    remove: (value, _silent)->
      _list= (val for val in _list when val isnt value)
      value?.onChange? _changed, true
      @length= _list.length
      _changed('remove') unless _silent
      this

    get: (index) -> 
      if arguments.length is 0
        (val?.get?() or val for val in _list)
      else
       _list[index]

    items: -> 
      _list

    clear: (_silent)->
      for value in _list
        @remove(value, true)
      _changed('clear', this) unless _silent
      this

    onChange: (fn, remove)->
      _listeners= [] unless _listeners?
      if remove
        _listeners= (cb for cb in _listeners when cb isnt fn) #excise fn, _listeners
      else
        unless fn in _listeners
          _listeners.push fn

  list.onChange(callback) if callback
  list.onChange.clear= -> _listeners= []
  if source
    list.add(item) for item in source
  list

((root)-> root.List = List)(module?.exports or this)
