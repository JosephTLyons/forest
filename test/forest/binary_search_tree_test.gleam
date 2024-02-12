import gleam/list
import gleam/option
import gleeunit/should
import forest/binary_search_tree as bst

pub fn insert_test() {
  let tree = bst.new()

  tree
  |> bst.to_list()
  |> should.equal([])

  let tree =
    tree
    |> bst.insert(1)

  tree
  |> bst.to_list()
  |> should.equal([1])

  let tree =
    tree
    |> bst.insert(0)

  tree
  |> bst.to_list()
  |> should.equal([0, 1])

  let tree =
    tree
    |> bst.insert(2)

  tree
  |> bst.to_list()
  |> should.equal([0, 1, 2])
}

pub fn contains_test() {
  let tree = bst.new()

  tree
  |> bst.contains(1)
  |> should.equal(False)

  let tree =
    tree
    |> bst.insert(1)

  tree
  |> bst.contains(1)
  |> should.equal(True)

  tree
  |> bst.contains(0)
  |> should.equal(False)

  tree
  |> bst.contains(2)
  |> should.equal(False)
}

// pub fn count_test() {
//   let tree =
//     bst.new()
//     |> bst.insert(6)
//     |> bst.insert(7)
//     |> bst.insert(0)
//     |> bst.insert(5)

//   tree
//   |> bst.count()
//   |> should.equal(5)
// }

pub fn to_list_test() {
  let items =
    bst.new()
    |> bst.insert(1)
    |> bst.insert(0)
    |> bst.insert(2)
    |> bst.to_list()

  items
  |> should.equal([0, 1, 2])
}
