
class Store  
  stores= {} # Cache so that multiple calls to Storage('name') will return the same instance
  
  constructor: (@storageKey, @backend=window['localStorage'])->
    return stores[@storageKey] if stores[@storageKey] isnt undefined
    return new Store(@storageKey, @backend) if this is _global
    throw new Error("Can't persist with a storage key.") unless @storageKey?
    throw new Error("Can't persist on this platform.") unless @backend?  
    return stores[@storageKey]= this

  save: (action, container)=>
    data= container.get()
    @backend.setItem( @storageKey, JSON.stringify(data) )

  load: (defaultData={})=>
    raw= @backend.getItem(@storageKey)
    if raw?
      data= JSON.parse(raw)
      # Parse data into hash/list structures
      @parse data
    else
      @parse defaultData

  parse: (data)->
    if type(data) is 'array'
      list= []
      list.push( @parse item ) for item in data
      List(list)
    else if type(data) is 'object'
      hash= {}
      for own key,value of data
        hash[key]= @parse(value)
      Hash(hash)
    else
      data

expose {
  Store
}

# USAGE

# store= Store('keyname')

# app_state= Hash(store.load({
#   default: 'value'
# }))

# app_state.onChange(store.save)
