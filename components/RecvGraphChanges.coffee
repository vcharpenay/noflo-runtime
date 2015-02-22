noflo = require 'noflo'

# @runtime all

class RecvGraphChanges extends noflo.AsyncComponent
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
    super 'runtime', 'out'

    @inPorts.on 'context', 'data', (@context) =>

  doAsync: (runtime, callback) ->
    @outPorts.out.connect()
    runtime.on 'graph', (data) ->
      rtGraph =
        processes: []
        connections: []
      if data.command == 'addnode'
        rtGraph.processes.push data.payload
      else if data.command == 'addedge'
        rtGraph.connections.push data.payload
      out = if @context then @context else {}
      out.runtimeGraph = rtGraph
      @outPorts.out.beginGroup runtime
      @outPorts.out.send out
      @outPorts.out.endGroup()
      callback null

exports.getComponent = -> new RecvGraphChanges
