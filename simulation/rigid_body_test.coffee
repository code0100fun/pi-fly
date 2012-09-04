Vector3 = require("../math/vector3")
Matrix3 = require("../math/matrix3")
RigidBody = require("./physics").RigidBody
Force = require("./physics").Force


radius = 40 #cm
mass = 0.300 #kgrams
angleDelta = (2 * Math.PI) / 3.0 #radians
rigidBody = new RigidBody()
inertiaTensor = new Matrix3([1, 0, 0, 0, 1, 0, 0, 0, 2])

#console.log(inertiaTensor);
#console.log(inertiaTensor.smult(Math.pow(mass,2)/2));
inertiaTensor.smult Math.pow(mass, 2) / 2
console.log inertiaTensor.elements
rigidBody.inertiaTensor = inertiaTensor

motor1 = new Force(new Vector3(Math.cos(0), 0, Math.sin(0)), new Vector3(0, 0, 0))
motor2 = new Force(new Vector3(Math.cos(angleDelta), 0, Math.sin(angleDelta)), new Vector3(0, 0, 0))
motor3 = new Force(new Vector3(Math.cos(2 * angleDelta), 0, Math.sin(2 * angleDelta)), new Vector3(0, 0, 0))
gravity = new Force(new Vector3(0, 0, 0), new Vector3(0, -1, 0))

rigidBody.addPointForce motor1
rigidBody.addPointForce motor2
rigidBody.addPointForce motor3
rigidBody.addGlobalForce gravity
rigidBody.update()

