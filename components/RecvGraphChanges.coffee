noflo = require 'noflo'

# @runtime all

class RecvGraphChanges extends noflo.Component
  constructor: ->
    @runtime = null
    @changes = []
    @inPorts = new noflo.InPorts
      runtime:
        datatype: 'object'
        description: 'FBP Runtime instance'
        required: true
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'object'
        description: 'Context object with graph changes'

    @inPorts.on 'runtime', 'data', (@runtime) =>
      @runtime.on 'graph', (data) =>
        @outPorts.out.send
          runtimeGraph: data

exports.getComponent = -> new RecvGraphChanges
