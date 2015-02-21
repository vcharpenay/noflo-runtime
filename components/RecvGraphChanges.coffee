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

    @inPorts.on 'context', 'data', (@context) =>

    @inPorts.on 'runtime', 'data', (runtime) ->
      runtime.on 'graph', @deliver

    deliver: (data) ->
      out = if @context then @context else {}
      if data.command == 'addnode'
        out.runtimeGraph.processes.push data.payload
      else if data.command == 'addedge'
        out.runtimeGraph.connections.push data.payload
      @outPorts.out.send out

exports.getComponent = -> new RecvGraphChanges
