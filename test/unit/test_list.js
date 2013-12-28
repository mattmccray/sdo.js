
describe('List', function(){

  it('should exist', function(){
      expect(List).to.exist
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