# Simple Data Objects

This is experimental, really. Just simple data objects that have a single `onChange` callback support.

```coffeescript
user= new Model name:'', email:''

user.onChange (keys)->
  console.log "changed", keys
  # keys are actually the keys used in the #set() call, api may change

user.set 'name', 'Matt'
# or
user.set email:'my@email.org'
```

Can extend the `Model` too, of course:

```coffeescript
class User extends Model
  default: ->
    name: ''
    email: ''

user= new User
```
