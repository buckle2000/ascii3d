lovernet = require 'lovernet'

NETWORK_PROTOCOL_VERSION = 0
local lnet

add_op = util.add_op

new_client = (pworld) ->
  lnet = lovernet.new!
  lnet\addOp 'connect'
  lnet\addOp 'disconnect'
  lnet\addOp 'move'
  lnet\addOp 'query'

new_client
