# Simple Data Objects

Very simple data object layer with simple `onChange` callback support.

You comprise your data model with just two object types: `Hash`, `List`

```coffeescript
users= List(
  Hash( name:'alice', email:'alice@test.com' )
  Hash( name:'bob', email:'bob@test.com' )
)
```

Both `Hash` and `List` have an `onChange` method to register for changes.

```coffeescript
users.onChange (action, list)->
  console.log "List changed", action
```

For Lists, the callback receives the action that took place (`add`, `remove`, 
`clear`) and the source List instance.

```coffeescript
Hash( test:yes ).onChange (keys, hash)->
  console.log "Hash changed", keys
```

For Hashes, the callback receives the keys that were changed (always an Array) 
and the source Hash instance.

All change events propagate upward.

```coffeescript
page= Hash( current:'home', params:null )

app= Hash( {page} )

app.onChange (keys, hash)->
  console.log "Something changed!"

page.set current:'about'

# app.onChange handler is called!
```

The `Store` type is for syncing objects to `localStorage` (or `sessionStorage`).


```coffeescript
store= Store('app.settings')
settings= Hash( store.load(
  font: 'Helvetica' # Default values are returned if no data was found in storage
))

settings.onChange( store.save )

settings.set font:'Comic Sans' # Ack! But automatically persisted
```

You can nest objects and selectively store at certain levels, if you want:

```coffeescript
class App
  constructor: ->
    store= Store( 'app.settings' )
    @state= Hash(
      page: Hash( current:'home', params:null )
      settings: Hash(store.load( font:'Helvetica' ))
      other: 'Whatever'
    )
    @state.get('settings').onChange(store.save)

app= new App
```

Only `app.state.settings` will be persisted in the `app.state` graph.

I use this with small React projects:

```coffeescript
{div}= React.DOM
_= null

state= Hash( 
  name:'Matt' 
  todos: List([
    Hash( title:'A todo', done:no )
    Hash( title:'Another todo', done:no )
  ])
)

Page= React.createClass
  render: ->
    (div _,
      "Welcome, #{ @props.name }"
    )

state.onChange ->
  React.renderComponent (Page state.get()), document.body

@onload= ->
  state.set loaded:yes
```

Oh yes, calling `get()` with no parameters will return a JSON-like structure,
very useful for splatting into React props as shown above.

[Run unit tests in your browser...](http://darthapo.github.io/sdo.js/test/)