
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

  clear: (_silent)->
    for value in @_list
      @remove(value, true)
    @_changed('clear', this) unless _silent
    this

  toString: -> "[object List]"

List= (base=[], callback)->
  list= Object.create(ListImpl)
  list._list=[]
  list._changed= list._changed.bind(list)
  list.addAll(base, true)
  list.onChange(callback) if callback?
  list

((root)-> root.List = List)(module?.exports or this)

# if module?
#   module.exports.List= List
# else
#   @List= List
