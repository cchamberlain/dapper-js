
var edge = require('edge')
  , path = require('path')
  , dapperService = edge.func(path.join('./lib/DapperService.cs'))

var helloworld = edge.func(function() {/*
    async (input) => {
      return ".NET Welcomes " + input.ToString();
    }
    
  */})

helloworld('JavaScript', function(err, result) {
  if (err) throw err;
  console.log(result);
})