#= require spec_helper

describe('Backbone', function() {
  it('exists in the namespace', function() {
    expect(Backbone).to.be.an('object');
  });
});

describe('Voyageur.Views.Location', function() {

  it('Exists in the namespace', function() {
    expect(Voyageur.Views.Location).to.be.a('function');
  });

});
