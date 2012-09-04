Vector3 = require("./vector3")

class Matrix3
  ###
  @class Matrix3
  @brief Produce a 3x3 matrix. Columns first!
  @param array elements Array of nine elements. Optional.
  @author schteppe / http://github.com/schteppe
  ###
  constructor: (elements) ->
    
    ###
    @property Float32Array elements
    @memberof Matrix3
    @brief A vector of length 9, containing all matrix elements
    ###
    if elements
      @elements = new Float32Array(elements)
    else
      @elements = new Float32Array(9)


  ###
  @fn identity
  @memberof Matrix3
  @brief Sets the matrix to identity
  @todo Should perhaps be renamed to setIdentity() to be more clear.
  @todo Create another function that immediately creates an identity matrix eg. eye()
  ###
  identity: ->
    @elements[0] = 1
    @elements[1] = 0
    @elements[2] = 0
    @elements[3] = 0
    @elements[4] = 1
    @elements[5] = 0
    @elements[6] = 0
    @elements[7] = 0
    @elements[8] = 1


  ###
  @fn vmult
  @brief Matrix-Vector multiplication
  @param Vector3 v The vector to multiply with
  @param Vector3 target Optional, target to save the result in.
  ###
  vmult: (v, target) ->
    target = new Vector3()  if target is `undefined`
    vec = [v.x, v.y, v.z]
    targetvec = [0, 0, 0]
    i = 0

    while i < 3
      j = 0

      while j < 3
        targetvec[i] += @elements[i + 3 * j] * vec[i]
        j++
      i++
    target.x = targetvec[0]
    target.y = targetvec[1]
    target.z = targetvec[2]
    target


  ###
  @fn smult
  @memberof Matrix3
  @brief Matrix-scalar multiplication
  @param float s
  ###
  smult: (s) ->
    i = 0

    while i < @elements.length
      console.log @elements[i], s
      @elements[i] *= s
      i++


  ###
  @fn mmult
  @memberof Matrix3
  @brief Matrix multiplication
  @param Matrix3 m Matrix to multiply with from left side.
  @return Matrix3 The result.
  ###
  mmult: (m) ->
    r = new Matrix3()
    i = 0

    while i < 3
      j = 0

      while j < 3
        sum = 0.0
        k = 0

        while k < 3
          sum += @elements[i + k] * m.elements[k + j * 3]
          k++
        r.elements[i + j * 3] = sum
        j++
      i++
    r


  ###
  @fn solve
  @memberof Matrix3
  @brief Solve Ax=b
  @param Vector3 b The right hand side
  @param Vector3 target Optional. Target vector to save in.
  @return Vector3 The solution x
  ###
  solve: (b, target) ->
    target = target or new Vector3()
    
    # Construct equations
    nr = 3 # num rows
    nc = 4 # num cols
    eqns = new Float32Array(nr * nc)
    i = undefined
    j = undefined
    i = 0
    while i < 3
      j = 0
      while j < 3
        eqns[i + nc * j] = @elements[i + 3 * j]
        j++
      i++
    eqns[3 + 4 * 0] = b.x
    eqns[3 + 4 * 1] = b.y
    eqns[3 + 4 * 2] = b.z
    
    # Compute right upper triangular version of the matrix - Gauss elimination
    n = 3
    k = n
    np = undefined
    kp = 4 # num rows
    p = undefined
    els = undefined
    loop
      i = k - n
      if eqns[i + nc * i] is 0
        j = i + 1
        while j < k
          if eqns[i + nc * j] isnt 0
            els = []
            np = kp
            loop
              p = kp - np
              els.push eqns[p + nc * i] + eqns[p + nc * j]
              break unless --np
            eqns[i + nc * 0] = els[0]
            eqns[i + nc * 1] = els[1]
            eqns[i + nc * 2] = els[2]
            break
          j++
      if eqns[i + nc * i] isnt 0
        j = i + 1
        while j < k
          multiplier = eqns[i + nc * j] / eqns[i + nc * i]
          els = []
          np = kp
          loop
            p = kp - np
            els.push (if p <= i then 0 else eqns[p + nc * j] - eqns[p + nc * i] * multiplier)
            break unless --np
          eqns[j + nc * 0] = els[0]
          eqns[j + nc * 1] = els[1]
          eqns[j + nc * 2] = els[2]
          j++
      break unless --n
    
    # Get the solution
    target.z = eqns[2 * nc + 3] / eqns[2 * nc + 2]
    target.y = (eqns[1 * nc + 3] - eqns[1 * nc + 2] * target.z) / eqns[1 * nc + 1]
    target.x = (eqns[0 * nc + 3] - eqns[0 * nc + 2] * target.z - eqns[0 * nc + 1] * target.y) / eqns[0 * nc + 0]
    throw "Could not solve equation! Got x=[" + target.toString() + "], b=[" + b.toString() + "], A=[" + @toString() + "]"  if isNaN(target.x) or isNaN(target.y) or isNaN(target.z) or target.x is Infinity or target.y is Infinity or target.z is Infinity
    target


  ###
  @fn e
  @memberof Matrix3
  @brief Get an element in the matrix by index. Index starts at 0, not 1!!!
  @param int i
  @param int j
  @param float value Optional. If provided, the matrix element will be set to this value.
  @return float
  ###
  e: (i, j, value) ->
    if value is `undefined`
      @elements[i + 3 * j]
    else
      
      # Set value
      @elements[i + 3 * j] = value


  ###
  @fn copy
  @memberof Matrix3
  @brief Copy the matrix
  @param Matrix3 target Optional. Target to save the copy in.
  @return Matrix3
  ###
  copy: (target) ->
    target = target or new Matrix3()
    i = 0

    while i < @elements.length
      target.elements[i] = @elements[i]
      i++
    target


  ###
  @fn toString
  @memberof Matrix3
  @brief Returns a string representation of the matrix.
  @return string
  ###
  toString: ->
    r = ""
    sep = ","
    i = 0

    while i < 9
      r += @elements[i] + sep
      i++
    r

  inverse: (target) ->
    target = target or new Matrix3()
    identity = new Matrix3()
    identity.identity()
    @solve identity, target
    target

module.exports = Matrix3

