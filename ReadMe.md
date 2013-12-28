# Simple Data Objects

This is experimental, really. Just simple data objects that support a single `onChange` callback.

```coffeescript
user= Hash name:'', email:''

user.onChange (keys)->
  console.log "changed", keys
  
user.set 'name', 'Matt'
# or
user.set email:'my@email.org'
```

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
