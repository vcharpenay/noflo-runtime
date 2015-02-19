noflo = require 'noflo'

# @runtime all

class RecvGraphChanges extends noflo.Component
  constructor: ->
    @runtime = null
    @graph = null
    @changes = []
    @changesStates = {}
    @inPorts = new noflo.InPorts
      in:
        datatype: 'bang'
        description: 'Test inport'
        required: true
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'object'
        description: 'Test outport'
        required: false

    @inPorts.on 'in', 'data', (@runtime) =>
      @outPorts.out.send
		nodes: 'could be anything right now'

exports.getComponent = -> new RecvGraphChanges
