
describe('SDO', function(){

  it('should exist', function(){
      expect(SDO).to.exist
  })

  describe('uid', function(){

    it('should exist', function() {
      expect( SDO.uid ).to.exist
    })    

    it('should generate a String', function() {
      expect( SDO.uid() ).to.be.a.String
    })

    it('should create a unique id', function() {
      var a= SDO.uid(),
          b= SDO.uid()
      expect(a).to.not.equal(b)
    })
  })

  describe('type', function(){
    
    it('should exist', function() {
      expect( SDO.type ).to.exist
    })    

    it('should correctly identify strings', function() {
      expect( SDO.type("Hello") ).to.equal('string')
    })

    it('should correctly identify numbers', function() {
      expect( SDO.type(10) ).to.equal('number')      
      expect( SDO.type(1.0) ).to.equal('number')
      expect( SDO.type(0) ).to.equal('number')
    })

    it('should correctly identify dates', function() {
      expect( SDO.type(new Date) ).to.equal('date')
    })

    it('should correctly identify objects', function() {
      expect( SDO.type({}) ).to.equal('object')
    })

    it('should correctly identify functions', function() {
      expect( SDO.type(function(){}) ).to.equal('function')
    })

    it('should correctly identify regexps', function() {
      expect( SDO.type(/test/) ).to.equal('regexp')
    })

    it('should correctly identify dom nodes', function() {
      expect( SDO.type(document.body) ).to.equal('bodyelement')
    })

    it('should correctly identify null', function() {
      expect( SDO.type(null) ).to.equal('null')
    })

    it('should correctly identify undefined', function() {
      var x= void 0
      expect( SDO.type(x) ).to.equal('undefined')
    })

  })

  describe('extend', function(){
    
    it('should exist', function() {
      expect( SDO.extend ).to.exist
    })

    it('should extend an object', function() {
      var target= {a:'A'},
          extra= {b:'B'},
          expected= {a:'A', b:'B'}
      expect( SDO.extend(target, extra) ).to.deep.equal(expected)
      expect( target ).to.deep.equal(expected)
    })

    it('should extend an object from multiple others', function() {
      var target= {a:'A'},
          extra= {b:'B'},
          more= {c:'C'},
          expected= {a:'A', b:'B', c:'C'}
      expect( SDO.extend(target, extra, more) ).to.deep.equal(expected)
      expect( target ).to.deep.equal(expected)
    })

    it('should write over existing keys', function() {
      var target= {a:'A'},
          extra= {a:'X', b:'B'},
          more= {a:'Z'},
          expected= {a:'X', b:'B'},
          expected2= {a:'Z', b:'B'}
      expect( SDO.extend(target, extra) ).to.deep.equal(expected)
      expect( SDO.extend({}, extra, more) ).to.deep.equal(expected2)
    })

  })

  describe('defaults', function(){
    
    it('should exist', function() {
      expect( SDO.defaults ).to.exist
    })    

    it('should extend an object', function() {
      var target= {a:'A'},
          extra= {b:'B'},
          expected= {a:'A', b:'B'}
      expect( SDO.defaults(target, extra) ).to.deep.equal(expected)
      expect( target ).to.deep.equal(expected)
    })

    it('should extend an object from multiple others', function() {
      var target= {a:'A'},
          extra= {b:'B'},
          more= {c:'C'},
          expected= {a:'A', b:'B', c:'C'}
      expect( SDO.defaults(target, extra, more) ).to.deep.equal(expected)
      expect( target ).to.deep.equal(expected)
    })

    it('should not write over existing keys', function() {
      var target= {a:'A'},
          extra= {a:'X', b:'B'},
          more= {a:'Z'},
          expected= {a:'A', b:'B'},
          expected2= {a:'X', b:'B'}
      expect( SDO.defaults(target, extra) ).to.deep.equal(expected)
      expect( SDO.defaults({}, extra, more) ).to.deep.equal(expected2)
    })
  })



  // describe('...', function(){
  //   beforeEach(function() {
  //     this.model = new SDO.Hash({ 
  //       username:'', 
  //       password:'' 
  //     })
  //   })

  //   afterEach(function() {
  //     this.model= null
  //   })

  //   it('should create methods', function(){
  //     expect(this.model.username).to.exist
  //     expect(this.model.password).to.exist
  //   })
  // })

})