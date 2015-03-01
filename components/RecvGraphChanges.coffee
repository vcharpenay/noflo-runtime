noflo = require 'noflo'

# @runtime all

class RecvGraphChanges extends noflo.Component
  constructor: ->
    @runtime = null
    @context = null
    @changes = []
    @inPorts = new noflo.InPorts
      runtime:
        datatype: 'object'
        description: 'FBP Runtime instance'
        required: true
      context:
        datatype: 'object'
        description: 'Existing context'
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'object'
        description: 'Merged context with changes'
      received:
        datatype: 'bang'
        description: 'Notification that a message was received'
    super 'runtime', 'out'

    @inPorts.on 'context', 'data', (@context) =>

    @inPorts.on 'runtime', 'data', (@runtime) =>
      runtime.on 'graph', (data) =>
        out = if @context then @context else {}
        @outPorts.out.send
          runtimeGraph: data
        @outPorts.received.beginGroup() @runtime.name if @runtime
        @outPorts.received.send true
        @outPorts.received.endGroup() if @runtime

exports.getComponent = -> new RecvGraphChanges
