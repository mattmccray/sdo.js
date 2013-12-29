
class Store
  
  stores= {} # For so that multiple calls to Storage('name') will return the same function
  
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

#return

# USAGE

# store= Store('keyname')

# app_state= Hash(store.load({
#   default: 'value'
# }))

# app_state.onChange(store.save)







# # Possible usages:

# app_state = Store(
#   Hash(
#     page: Hash(
#       current: 'home'
#       params: []
#     )
#   )
#   window.sessionStorage
# )

# app_state= Hash(
#   page:
#     current: 'home'
#     params: []
# )

# app_state.onChange(Store('app_state'))

# app_state.set('page', {

#   })

# users= List()

# users.onChange(Store('users'))

# # actually returns the hash for you to return


# # Graph?
# g= Graph({
#   page: {
#     current: 'home'
#     params: []
#   }
# })

# g.set('page.current', 'about')
# #                      key,            value,   oldValue
# #=> triggers onChange('page.current', 'about', 'home')


# g.set('name', 'stuff')
# g.set({ name:'more' })
# g.get('name')