
class Hash extends OnChange
  constructor: (source, callback)->
    return new Hash(source, callback) if this is _global
    super
    @_atts= {}
    @set(source) if source
    @onChange(callback) if callback
  
  set: (key, value, _silent)->
    if arguments.length is 2
      @_setPair key, value, _silent
    else
      @_setObject key, _silent

  replace: (key, value, _silent)->
    @remove(key, _silent, yes)
    @set(key, value, _silent)

  get: (key)->
    if arguments.length is 1
      @_atts[key]
    else
      atts={}
      for key,value of @_atts
        atts[key]= value?.get?() or value
      atts

  remove: (key, _silent, _skipDelete)->
    value= @get(key)
    if value isnt undefined
      value?.onChange?(@_notifyChange, false)
      delete @_atts[key] unless _skipDelete
      @_notifyChange([key]) unless _silent
    value

  _setPair: (key, value, _silent)->
    if value isnt @_atts[key]
      @remove key, yes, yes
      @_atts[key]= value
      @_notifyChange([key]) unless _silent
      value?.onChange?(@_notifyChange)
      yes
    else
      no

  _setObject: (hash, _silent)->
    keys= []
    for own key,value of hash
      keys.push(key) if @_setPair key, value, yes
    if keys.length > 0
      @_notifyChange(keys) unless _silent
      yes
    else
      no

expose {
  Hash
}
# ((root)-> root.Hash = Hash)(module?.exports or this)
