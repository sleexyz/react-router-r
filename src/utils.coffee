module.exports =
  invariant: (cond, msg) ->
    unless cond
      error = new Error cond
      error.framesToPop = 1
      throw error
