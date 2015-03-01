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
      received:
        datatype: 'bang'
        description: 'Notification that a message was received'

    @inPorts.on 'runtime', 'data', (@runtime) =>
      runtime.on 'graph', (data) =>
        @outPorts.out.send
          runtimeGraph: data
        @outPorts.received.beginGroup() @runtime.name if @runtime
        @outPorts.received.send true
        @outPorts.received.endGroup() if @runtime

exports.getComponent = -> new RecvGraphChanges
