import gleam/int
import gleam/option.{type Option, None, Some}
import gleam/order
import gleam/result
import gleam/list

// TODO
// Make tree generic
// Finish methods
//    use `set`'s interface
// Order of api and tests

pub opaque type NodeState {
  NodeState(value: Int, left: Option(Node), right: Option(Node))
}

pub opaque type Node {
  Node(state: option.Option(NodeState))
}

pub fn new() -> Node {
  Node(state: None)
}

pub fn insert(tree: Node, value: Int) -> Node {
  case tree.state {
    Some(state) ->
      case int.compare(state.value, value) {
        order.Lt ->
          Node(Some(
            NodeState(..state, right: update_subtree(state.right, value)),
          ))
        order.Gt ->
          Node(Some(NodeState(..state, left: update_subtree(state.left, value))))
        order.Eq -> tree
      }
    None ->
      Node(Some(NodeState(value: value, left: option.None, right: option.None)))
  }
}

fn update_subtree(subtree: Option(Node), value: Int) -> Option(Node) {
  case subtree {
    Some(node) -> Some(insert(node, value))
    None -> Some(Node(Some(NodeState(value: value, left: None, right: None))))
  }
}

// pub fn remove(tree: Node, value: Int) -> Node {
//   todo
// }

pub fn contains(tree: Node, value: Int) -> Bool {
  case tree.state {
    Some(state) ->
      case int.compare(state.value, value) {
        order.Lt ->
          state.right
          |> option.map(fn(node) { contains(node, value) })
          |> option.unwrap(False)
        order.Gt ->
          state.left
          |> option.map(fn(node) { contains(node, value) })
          |> option.unwrap(False)
        order.Eq -> True
      }
    None -> False
  }
}

// pub fn path(tree: Node, value: Int) -> Result(List(Int), Nil) {
//   Error(Nil)
// }

// pub fn debug_print(tree: Node) {
//   todo
// }

// pub fn balance(tree: Node) -> Node {
//   todo
// }

// pub fn height() -> Int {
//   0
// }

// pub fn depth() -> Int {
//   0
// }

// pub fn count(tree: Node) -> Int {
//   io.debug(tree)
//   let left = case tree.left {
//     Some(node) -> count(node)
//     None -> 0
//   }

//   let right = case tree.right {
//     Some(node) -> count(node)
//     None -> 0
//   }

//   io.debug("left")
//   io.debug(left)
//   io.debug("left")
//   io.debug(right)

//   1 + left + right
// }

pub fn to_list(tree: Node) -> List(Int) {
  case tree.state {
    Some(state) -> {
      let left =
        state.left
        |> option.map(to_list)
        |> option.unwrap([])

      let right =
        state.right
        |> option.map(to_list)
        |> option.unwrap([])

      [left, [state.value], right]
      |> list.flatten()
    }
    None -> []
  }
}
// // Might not make sense - could just call insert in a loop
// pub fn from_list() -> List(Int) {
//   []
// }

// pub fn min() -> Int {
//   0
// }

// pub fn max() -> Int {
//   0
// }
