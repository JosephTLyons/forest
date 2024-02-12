import gleam/int
import gleam/option.{type Option, None, Some}
import gleam/order
import gleam/result
import gleam/io

// TODO
// Make tree generic
// Make type opaque - how to test easily?
// Finish methods

pub type Node {
  Node(value: Int, left: Option(Node), right: Option(Node))
}

pub fn new(value: Int) -> Node {
  Node(value: value, left: None, right: None)
}

pub fn insert(tree: Node, value: Int) -> Node {
  case int.compare(tree.value, value) {
    order.Lt -> Node(..tree, right: update_subtree(tree.right, value))
    order.Gt -> Node(..tree, left: update_subtree(tree.left, value))
    order.Eq -> tree
  }
}

fn update_subtree(subtree: Option(Node), value: Int) -> Option(Node) {
  case subtree {
    Some(node) -> Some(insert(node, value))
    None -> Some(Node(value: value, left: None, right: None))
  }
}

pub fn remove(tree: Node, value: Int) -> Node {
  todo
}

pub fn contains(tree: Node, value: Int) -> Bool {
  case int.compare(tree.value, value) {
    order.Lt ->
      tree.right
      |> option.map(fn(node) { contains(node, value) })
      |> option.unwrap(False)
    order.Gt ->
      tree.left
      |> option.map(fn(node) { contains(node, value) })
      |> option.unwrap(False)
    order.Eq -> True
  }
}

pub fn path(tree: Node, value: Int) -> Result(List(Int), Nil) {
  Error(Nil)
}

pub fn debug_print(tree: Node) {
  todo
}

pub fn balance(tree: Node) -> Node {
  todo
}

pub fn height() -> Int {
  0
}

pub fn depth() -> Int {
  0
}

pub fn count(tree: Node) -> Int {
  io.debug(tree)
  let left = case tree.left {
    Some(node) -> count(node)
    None -> 0
  }

  let right = case tree.right {
    Some(node) -> count(node)
    None -> 0
  }

  io.debug("left")
  io.debug(left)
  io.debug("left")
  io.debug(right)

  1 + left + right
}

pub fn to_list() -> List(Int) {
  []
}

// Might not make sense - could just call insert in a loop
pub fn from_list() -> List(Int) {
  []
}

pub fn min() -> Int {
  0
}

pub fn max() -> Int {
  0
}
