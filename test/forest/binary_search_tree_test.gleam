import gleam/option
import gleeunit/should
import forest/binary_search_tree as bst

pub fn insert_test() {
  let tree = bst.new(5)

  tree
  |> should.equal(bst.Node(value: 5, left: option.None, right: option.None))

  let tree =
    tree
    |> bst.insert(4)

  tree
  |> should.equal(bst.Node(
    value: 5,
    left: option.Some(bst.Node(value: 4, left: option.None, right: option.None)),
    right: option.None,
  ))

  let tree =
    tree
    |> bst.insert(6)

  tree
  |> should.equal(bst.Node(
    value: 5,
    left: option.Some(bst.Node(value: 4, left: option.None, right: option.None)),
    right: option.Some(bst.Node(value: 6, left: option.None, right: option.None)),
  ))

  let tree =
    tree
    |> bst.insert(0)

  tree
  |> should.equal(bst.Node(
    value: 5,
    left: option.Some(bst.Node(
      value: 4,
      left: option.Some(bst.Node(
        value: 0,
        left: option.None,
        right: option.None,
      )),
      right: option.None,
    )),
    right: option.Some(bst.Node(value: 6, left: option.None, right: option.None)),
  ))

  let tree =
    tree
    |> bst.insert(10)

  tree
  |> should.equal(bst.Node(
    value: 5,
    left: option.Some(bst.Node(
      value: 4,
      left: option.Some(bst.Node(
        value: 0,
        left: option.None,
        right: option.None,
      )),
      right: option.None,
    )),
    right: option.Some(bst.Node(
      value: 6,
      left: option.None,
      right: option.Some(bst.Node(
        value: 10,
        left: option.None,
        right: option.None,
      )),
    )),
  ))
}

pub fn contains_test() {
  let tree =
    bst.new(5)
    |> bst.insert(6)
    |> bst.insert(7)
    |> bst.insert(0)
    |> bst.insert(5)

  tree
  |> bst.contains(5)
  |> should.equal(True)

  tree
  |> bst.contains(6)
  |> should.equal(True)

  tree
  |> bst.contains(7)
  |> should.equal(True)

  tree
  |> bst.contains(0)
  |> should.equal(True)

  tree
  |> bst.contains(5)
  |> should.equal(True)

  tree
  |> bst.contains(10)
  |> should.equal(False)
}

pub fn count_test() {
  let tree =
    bst.new(5)
    |> bst.insert(6)
    |> bst.insert(7)
    |> bst.insert(0)
    |> bst.insert(5)

  tree
  |> bst.count()
  |> should.equal(5)
}
