helpers.extend global, require('./test-helper')

u: m: null
before ->
  u: new Lz.Universe()
  m: new Lz.Mass()
  u.add m

test "initialize", (t) ->
  t.expect 1
  t.ok new Lz.Universe(), 'can initialize universe'
  t.done()

test "add", (t) ->
  t.expect 2
  t.equals m.universe, u, 'mass has correct universe'
  t.equals 1, u.masses.length, 'universe has 1 mass'
  t.done()

test "step", (t) ->
  t.expect 1
  start: m.position.clone()
  velocity: new Lz.Vector(1, 0)
  m.velocity: velocity.clone()
  u.step 1
  t.same start.plus(velocity), m.position
  t.done()

test "network add does not update ntick", (t) ->
  m1: new Lz.Mass()

  # TODO use mocks instead of updating private vars
  u.io.inbox.push ['add', m1.pack()]
  u.step 100
  u.network()

  m2: u.masses.find m1

  t.same m1.ntick, m2.ntick
  t.done()

test "ship expires", (t) ->
  s: new Lz.Ship()
  u.add s
  u.step s.lifetime + 1
  t.ok !u.masses.find s, "ship removed from universe"
  t.done()

test "primary ship doesn't expire", (t) ->
  s: new Lz.Ship()
  u.add s
  u.ship: s
  u.step s.lifetime + 1
  t.ok u.masses.find s, "ship remains in universe"
  t.done()

run(__filename)