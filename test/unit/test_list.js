
describe('List', function(){

  it('should exist', function(){
      expect(List).to.exist
  })

  it('should allow adding values', function() {
    var list= List(),
        count= 0
    list.onChange(function() {
      count += 1
    })

    list.add('First')
    expect( list.length ).to.equal(1)
    expect( count ).to.equal(1)
  })

  it('should allow removing values', function() {
    var list= List(['first']),
        count= 0
    list.onChange(function() {
      count += 1
    })

    list.remove(0)
    expect( list.length ).to.equal(0)
    expect( count ).to.equal(1)
    
  })

  it('should fire onChange handlers', function() {
    var l= List(['first']),
        count= 0
    
    l.onChange(function(action, list){
      count += 1
      expect( action ).to.exist
      expect( action ).to.be.a.String

      expect( list ).to.exist
      expect( list ).to.equal(l)
    })

    l.add('new')
    expect( count ).to.equal(1)
    expect( l.length ).to.equal(2)

    l.remove( 0 )
    expect( count ).to.equal(2)
    expect( l.length ).to.equal(1)
  })

it('should propagate change events from nested hashes', function() {
    var count= 0,
        child= Hash({ 
          name:'Kid' 
        }),
        parent= List([
          'first',
          child
        ])
    parent.onChange(function() {
      count += 1
    })

    parent.add('new')
    expect( count ).to.equal(1)

    child.set('name', 'Terror')
    expect( count ).to.equal(2)
    
  })

  it('should propagate change events from nested lists', function() {
    var count= 0,
        favs= List(['chocolate']),
        items= List([
          favs
        ]),
        deepCount= 0,
        deeplynested= List([
          Hash({
            sub: List(favs)
          })
        ])
    
    items.onChange(function() {
      // console.log("onChange", arguments)
      count += 1
    })
    deeplynested.onChange(function() {
      deepCount += 1 
    })

    items.add('item')
    expect( count ).to.equal(1)

    favs.add('fast cars')
    expect( count ).to.equal(2)
    expect( deepCount ).to.equal(1)
  })

})


function perfList() {

  simplePerf('List speed', {}, {
    'v1 test': function() {
      var h= List(['matt']),
          count=  0,
          incr= function() { count += 1 }
      h.onChange(incr)
      h.add('name')
      h.add('name')
      h.get(0)
      h.onChange(incr, true)
      h.add({
        a:'A',
        b:'B'
      })
      h.onChange(incr)
      h.add({
        a:'A',
        b:'B',
        c:'A',
        d:'B',
        e: 'E',
        f: 'F'
      })

      h.onChange(incr, true)
  },
  'v2 (original) test': function() {
      var h= List2(['matt']),
          count=  0,
          incr= function() { count += 1 }
      h.onChange(incr)
      h.add('name')
      h.add('name')
      h.get(0)
      h.onChange(incr, true)
      h.add({
        a:'A',
        b:'B'
      })
      h.onChange(incr)
      h.add({
        a:'A',
        b:'B',
        c:'A',
        d:'B',
        e: 'E',
        f: 'F'
      })

      h.onChange(incr, true)
  },
  // 'v1 mass construction': function() {
  //   var x= Hash({ name:'Matt' }),
  //       count= 0,
  //       h= Hash({
  //         a: Hash({
  //           b: Hash({
  //             c: Hash({
  //               x:x
  //             })
  //           })
  //         })
  //       })
  //   h.onChange(function() {
  //     count += 1
  //   })
  //   x.set('name', 'Dan')
  //   if(count != 1) {
  //     throw new Error("expected callback count to be 1, was "+ count)
  //   }
  // },
//     'v2 mass construction': function() {
//     var x= Hash2({ name:'Matt' }),
//         count= 0,
//         h= Hash2({
//           a: Hash2({
//             b: Hash2({
//               c: Hash2({
//                 x:x
//               })
//             })
//           })
//         })
//     h.onChange(function() {
//       count += 1
//     })
//     x.set('name', 'Dan')
//     if(count != 1) {
//       throw new Error("expected callback count to be 1, was "+ count)
//     }
//   }
})


}