
describe('Hash', function(){

  it('should exist', function(){
      expect(Hash).to.exist
      //expect(this.model.password).to.exist
  })

  it('should accept initial values in constructor', function() {
    var h= Hash({ name:'test' })
    // .atts is internal, you should reach in like this yourself
    expect( h._atts ).to.deep.equal({ name:'test' })
  })

  it('should allow attribute access via get/set', function() {
    var h= Hash({ name:'test' })
    expect( h.get('name') ).to.equal('test')
    
    h.set('name', 'other')
    expect( h.get('name') ).to.equal('other')
    
    h.set({ name:'last' })
    expect( h.get('name') ).to.equal('last')
  })

  it('should fire onChange handlers', function() {
    var h= Hash({ name:'test' }),
        count= 0
    
    h.onChange(function(keys, hash){
      count += 1
      expect( keys ).to.exist
      expect( keys ).to.be.an.Array
      expect( keys.length ).to.equal(1)
      expect( keys[0] ).to.equal('name')

      expect( hash ).to.exist
      expect( hash ).to.equal(h)
    })

    h.set({ name:'New Name '})
    expect( count ).to.equal(1)

    // Should NOT fire a second time
    h.set( 'name', 'New Name ' )
    expect( count ).to.equal(1)
  })

  it('should batch onChange call when setting multiple values', function() {
    var h= Hash({ name:'test' }),
        count= 0
    
    h.onChange(function(keys){
      count += 1
      expect( keys ).to.be.an.Array
      expect( keys.length ).to.equal(2)
    })

    h.set({ 
      name:'New Name',
      other:'Another fing'
    })
    expect( count ).to.equal(1)
  })

  it('should send the keys of only the changed properties to onChange', function() {
    var h= Hash({ name:'test' }),
        count= 0
    
    h.onChange(function(keys){
      count += 1
      expect( keys ).to.be.an.Array
      expect( keys.length ).to.equal(1)
      expect( keys[0] ).to.equal('other')
    })

    h.set({ 
      name:'test',
      other:'Another fing'
    })
    expect( count ).to.equal(1)
    
  })

  it('should flatten out hashes if get is called with no index', function() {
    var h= Hash({
      page: Hash({
        current: 'home'
      }),
      prefs: Hash({
        autoLogin: true
      })
    })
    var expected= {
      page: {
        current: 'home'
      },
      prefs: {
        autoLogin: true
      }
    }
    expect( h.get() ).to.deep.equal(expected)
  })

  xit('should not try to track null values', function() {
    
  })

  xit('should merge hashes/lists on set', function() {
    
  })

  it('should propagate change events from nested hashes', function() {
    var count= 0,
        child= Hash({ 
          name:'Kid' 
        }),
        parent= Hash({
          name:'Sir',
          child:child
        })
    parent.onChange(function() {
      count += 1
    })

    parent.set('name', 'Maam')
    expect( count ).to.equal(1)

    child.set('name', 'Terror')
    expect( count ).to.equal(2)
    
  })

  it('should propagate change events from nested lists', function() {
    var count= 0,
        favs= List(['chocolate']),
        person= Hash({
          name:'Dude',
          favs:favs
        })
    
    person.onChange(function() {
      // console.log("onChange", arguments)
      count += 1
    })

    person.set('name', 'Dudette')
    expect( count ).to.equal(1)

    favs.add('fast cars')
    expect( count ).to.equal(2)
    
  })

  // xit('should allow sub classing', function() {
  //   var User= SDO.Hash.extend({
  //     stuff: function() {
  //       return 'user'
  //     }
  //   })


  //   var user= new User({ name:'viper' })
  //   expect(user).to.exist
    
  //   expect(user).to.have.property('get')
  //   expect(user).to.have.property('set')
  //   expect(user).to.have.property('stuff')
    
  //   expect(user.get).to.be.a.Function
  //   expect(user.set).to.be.a.Function
  //   expect(user.stuff).to.be.a.Function

  //   expect(user.get('name')).to.equal('viper')
  //   expect(user.stuff()).to.equal('user')
  // })

  // xit('should be populated with defaults() if they exist', function() {
  //   var User= SDO.Hash.extend({
  //     defaults: function() {
  //       return {
  //         type: 'user'
  //       }
  //     }
  //   })

  //   var user= new User({ name:'viper' })
  //   expect(user).to.exist
  //   expect(user.get('type')).to.equal('user')
  //   expect(user.get('name')).to.equal('viper')

  //   var user2= new User({ name:'gunstar', type:'admin' })
  //   expect(user2).to.exist
  //   expect(user2.get('type')).to.equal('admin')
  //   expect(user2.get('name')).to.equal('gunstar')
    
  // })

})