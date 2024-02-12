import gleam/int
import gleam/list
import gleeunit/should
import forest/binary_search_tree as bst

pub fn insert_test() {
  let tree = bst.new()

  tree
  |> bst.to_list()
  |> should.equal([])

  let tree =
    tree
    |> bst.insert(1, int.compare)

  tree
  |> bst.to_list()
  |> should.equal([1])

  let tree =
    tree
    |> bst.insert(0, int.compare)

  tree
  |> bst.to_list()
  |> should.equal([0, 1])

  let tree =
    tree
    |> bst.insert(2, int.compare)
    // Ensure duplicates aren't added
    |> bst.insert(2, int.compare)

  tree
  |> bst.to_list()
  |> should.equal([0, 1, 2])
}

pub fn contains_test() {
  bst.new()
  |> bst.contains(1, int.compare)
  |> should.equal(False)

  let tree = bst.from_list(mixed_ints(), int.compare)

  mixed_ints()
  |> list.map(fn(item) {
    tree
    |> bst.contains(item, int.compare)
  })
  |> list.all(fn(_) { True })

  tree
  |> bst.contains(min_int() - 1, int.compare)
  |> should.equal(False)

  tree
  |> bst.contains(max_int() + 1, int.compare)
  |> should.equal(False)
}

pub fn height_test() {
  bst.new()
  |> bst.height()
  |> should.equal(-1)

  bst.from_list([1, 0, 2], int.compare)
  |> bst.height()
  |> should.equal(1)

  bst.from_list(mixed_ints(), int.compare)
  |> bst.height()
  |> should.equal(5)
}

pub fn size_test() {
  bst.new()
  |> bst.size()
  |> should.equal(0)

  bst.from_list(mixed_ints(), int.compare)
  |> bst.size()
  |> should.equal(list.length(mixed_ints()))
}

pub fn from_list_test() {
  bst.from_list([], int.compare)
  |> bst.to_list()
  |> should.equal([])

  bst.from_list(mixed_ints(), int.compare)
  |> bst.to_list()
  |> should.equal(sorted_ints())
}

pub fn to_list_test() {
  bst.new()
  |> bst.to_list()
  |> should.equal([])

  bst.from_list(mixed_ints(), int.compare)
  |> bst.to_list
  |> should.equal(sorted_ints())
}

pub fn min_test() {
  bst.new()
  |> bst.min()
  |> should.equal(Error(Nil))

  bst.from_list(mixed_ints(), int.compare)
  |> bst.min()
  |> should.equal(Ok(min_int()))
}

pub fn max_test() {
  bst.new()
  |> bst.max()
  |> should.equal(Error(Nil))

  bst.from_list(mixed_ints(), int.compare)
  |> bst.max()
  |> should.equal(Ok(max_int()))
}

fn mixed_ints() -> List(Int) {
  [8, 2, 5, 7, 3, 9, 1, 6, 10, 4]
}

fn sorted_ints() -> List(Int) {
  mixed_ints()
  |> list.sort(int.compare)
}

fn min_int() -> Int {
  let assert Ok(min_int) =
    mixed_ints()
    |> list.reduce(int.min)

  min_int
}

fn max_int() -> Int {
  let assert Ok(max_int) =
    mixed_ints()
    |> list.reduce(int.max)

  max_int
}
