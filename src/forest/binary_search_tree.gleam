import gleam/int
import gleam/list
import gleam/option
import gleam/order

// TODO
// Finish methods
//     use `set`'s interface
// Order of api and tests
// Do we really want to have to pass in a `compare` function into the public api?
// Where can we refactor?
// Implement binary search tree with a binary tree?
//     Impelemnt binary tree with a tree?

pub opaque type NodeState(a) {
  NodeState(
    value: a,
    left: option.Option(Node(a)),
    right: option.Option(Node(a)),
  )
}

pub opaque type Node(a) {
  Node(state: option.Option(NodeState(a)))
}

pub fn new() -> Node(a) {
  Node(state: option.None)
}

pub fn value(node: Node(a)) -> option.Option(a) {
  node.state
  |> option.map(fn(state) { state.value })
}

pub fn insert(
  node: Node(a),
  value: a,
  compare: fn(a, a) -> order.Order,
) -> Node(a) {
  case node.state {
    option.Some(state) ->
      case compare(state.value, value) {
        order.Lt ->
          Node(option.Some(
            NodeState(
              ..state,
              right: option.Some(build_subtree(state.right, value, compare)),
            ),
          ))
        order.Gt ->
          Node(option.Some(
            NodeState(
              ..state,
              left: option.Some(build_subtree(state.left, value, compare)),
            ),
          ))
        order.Eq -> node
      }
    option.None ->
      Node(
        option.Some(NodeState(
          value: value,
          left: option.None,
          right: option.None,
        )),
      )
  }
}

fn build_subtree(
  node: option.Option(Node(a)),
  value: a,
  compare: fn(a, a) -> order.Order,
) -> Node(a) {
  case node {
    option.Some(node) -> insert(node, value, compare)
    option.None ->
      Node(
        option.Some(NodeState(
          value: value,
          left: option.None,
          right: option.None,
        )),
      )
  }
}

// pub fn delete(node: Node(a), value: a) -> Node(a) {
//   case node.state {
//     Some(node) -> {
//       todo
//     }
//     None -> node
//   }
// }

pub fn search(
  node: Node(a),
  value: a,
  compare: fn(a, a) -> order.Order,
) -> option.Option(Node(a)) {
  case node.state {
    option.Some(state) ->
      case compare(state.value, value) {
        order.Lt ->
          state.right
          |> option.map(fn(node) { search(node, value, compare) })
          |> option.unwrap(option.None)
        order.Gt ->
          state.left
          |> option.map(fn(node) { search(node, value, compare) })
          |> option.unwrap(option.None)
        order.Eq -> option.Some(node)
      }
    option.None -> option.None
  }
}

pub fn contains(
  node: Node(a),
  value: a,
  compare: fn(a, a) -> order.Order,
) -> Bool {
  node
  |> search(value, compare)
  |> option.is_some()
}

// pub fn path(node: Node, value: a) -> Result(List(a), Nil) {
//   Error(Nil)
// }

// pub fn debug_print(node: Node) {
//   todo
// }

// pub fn balance(node: Node) -> Node {
//   todo
// }

pub fn height(node: Node(a)) -> Int {
  case node.state {
    option.Some(state) -> {
      let left =
        state.left
        |> option.map(height)
        |> option.unwrap(-1)

      let right =
        state.right
        |> option.map(height)
        |> option.unwrap(-1)

      1 + int.max(left, right)
    }
    option.None -> -1
  }
}

// pub fn depth() -> a {
//   0
// }

pub fn size(node: Node(a)) -> Int {
  case node.state {
    option.Some(state) -> {
      let left =
        state.left
        |> option.map(size)
        |> option.unwrap(0)

      let right =
        state.right
        |> option.map(size)
        |> option.unwrap(0)

      1 + left + right
    }
    option.None -> 0
  }
}

pub fn from_list(items: List(a), compare: fn(a, a) -> order.Order) -> Node(a) {
  let node = new()
  case items {
    [] -> node
    items -> do_from_list(node, items, compare)
  }
}

fn do_from_list(
  node: Node(a),
  items: List(a),
  compare: fn(a, a) -> order.Order,
) -> Node(a) {
  case items {
    [] -> node
    [first, ..items] ->
      do_from_list(insert(node, first, compare), items, compare)
  }
}

pub fn to_list(node: Node(a)) -> List(a) {
  case node.state {
    option.Some(state) -> {
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
    option.None -> []
  }
}

pub fn min(node: Node(a)) -> option.Option(a) {
  node.state
  |> option.map(fn(state) {
    state.left
    |> option.map(min)
    |> option.unwrap(option.Some(state.value))
  })
  |> option.flatten()
}

pub fn max(node: Node(a)) -> option.Option(a) {
  node.state
  |> option.map(fn(state) {
    state.right
    |> option.map(max)
    |> option.unwrap(option.Some(state.value))
  })
  |> option.flatten()
}
