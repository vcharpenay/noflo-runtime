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

    @inPorts.on 'runtime', 'data', (runtime) ->
      runtime.on 'graph', @deliver

  doAsync: (runtime, callback) ->
    @outPorts.out.connect()
    runtime.on 'data', (data) ->
      rtGraph =
        processes: []
        connections: []
      if data.command == 'addnode'
        runtimeGraph.processes.push data.payload
      else if data.command == 'addedge'
        runtimeGraph.connections.push data.payload
      out = if @context then @context else {}
      out.runtimeGraph = rtGraph
      @outPorts.out.beginGroup runtime
      @outPorts.out.send out
      @outPorts.out.endGroup()
      callback null

exports.getComponent = -> new RecvGraphChanges
