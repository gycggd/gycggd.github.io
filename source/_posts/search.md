---
title: 总结总结搜索
date: 2017-09-13 22:34:07
tags: 
    - Artificial Intelligence
    - Algorithm
    - Search
---

# 开始

先放一张女神照。

![高圆圆](/images/search/gyy.jpeg)

搜索可以总结为从一个初始状态出发，找到一条路径能够到达目标点。其中每一条路径对应着状态的转移，同时每一条路径可能对应着一个状态值(Cost)，因此有不同方式到达目标点时，代价可能是不同的。

对于一个搜索策略来说，我们会关心以下几个问题：

* 如果存在路径能够到达目标点，该策略是否一定能找到(Completeness)
* 该策略找到的路径是否为最优路径(Optimal)，即路径代价最小（Mnimal Path Cost）
* 策略的时间复杂度(Time Complexity)与空间复杂度(Space Complexity)

![8-puzzle-problem](/images/search/8-puzzle.png)

上图的8-puzzle problem便是一个搜索问题，每一次移动便对应着一次状态转移，当中间为空所有数字按大小呈顺时针从左上角排列时，就完成了目标

## 搜索类型

根据搜索过程中是否利用到未遇到的节点的信息，可以分成以下两类

* 盲目搜索 Uninformed(Blind) Search 
* 启发式搜索 Informed(Heuristic) Search

# 盲目搜索 Uninformed(Blind) Search 

盲目搜索即搜索过程中对于每一个状态与目标状态的距离没有任何评估，盲目地进行状态转换。

搜索的过程可以看做是所有可达状态的一个树状结构：

1. 根节点为初始状态
2. 每一步搜索从一个节点开始，做一个状态转换，生成一条边连接到新的状态节点

```
function GENERAL-SEARCH( problem, strategy) 
# returns a solution, or failure initialize the search tree using the initial state of problem
    loop do
        if there are no candidates for expansion then return failure
            choose a leaf node for expansion according to strategy
            if the node contains a goal state 
                return the corresponding solution 
            else 
                expand the node and add the resulting nodes to the search tree
    end
```

## 8 Puzzle Problem

### 广度优先搜索

广度优先搜索在每一步会展开所有的叶子节点。下图为8-puzzle problem的广度优先搜索示意图

![breadth-first for 8-puzzle problem](/images/search/8-puzzle-breadth.png)

### 深度优先搜索

深度优先搜索为按照一个节点开始进行状态转换，直到到达最大深度或者没有状态可以转换，再backtrace到前面。下图为8-puzzle problem的深度优先搜索示意图

![depth-first for 8-puzzle problem](/images/search/8-puzzle-depth.png)

### 对比广度与深度优先搜索

|  | 时间复杂度 | 空间复杂度 | 是否最优 | 是否完整 |
|---|----|----|----|----|
| 广度优先 | $b^d$ | $b^d$ | 是 | 是 |
| 深度优先 | $b^m$ | $bm$ | 否 | $b>=d$ |

## 问题

* 避免重复到达某个状态，即状态树中每个节点都是唯一
* 深度优先搜索如何求得最优解：可以使用`Iterative Deepening`，逐步增加最大深度，如下图所示

![Iterative Deepening](/images/search/iterative-deepen.png)

# 启发式搜索 Informed(Heuristic) Search

启发式搜索可以用在机器学习的一些优化问题当中，比如说神经网络的调参。

启发式搜索在选择路径时会考虑下面的节点距离目标点还有多少的距离，用`Heuristic Function`来衡量。下面还是以8-puzzle problem为例：

```
# Heuristic Function of 8 Puzzle Problem
f(n) = number of tiles out of place compared with goal
```

这里的`Heuristic Function`用不在正确位置的方块的数目来衡量当前状态与目标点之间的距离

下图是每一个状态对应的`Heuristic Function`的值

![Heuristic search for 8-puzzle](/images/search/8-puzzle-heuristic.png)

加上`Path Cost`之后的搜索过程如下图：

![Heuristic search for 8-puzzle with path cost](/images/search/8-puzzle-heuristic-with-path-cost.png)

## A* Search

A* Search是经典的启发式搜索算法，常被用在寻路问题当中，涉及到的Cost Function有如下两个：

1. Path Cost，已经经过的路径的值，`g(x)`
2. Estimated Cost，当前节点距离目标点的估计值，`h(x)`

所以节点与目标点的距离就可以用两者之和`f(x)=g(x)+h(x)`来衡量了。

A* Search的流程如下：

``` python
OPEN = [$n_0$]      # initialize OPEN, $n_0$ is root/start node
CLOSED = []

while True:

    if isEmpty(OPEN):
        return False    # There is no path from start to goal

    n = OPEN.pop(0)     # Get the node with lowest cost
    CLOSED.add(n)            # Add n to explored nodes
    if isGoal(n):       # Return the path if reach the goal
        return path     

    succs = succ(n).filter(lambda x:x not in ancestor(n))    # Get successors of node n
    for m in succs:
        OPEN.append(m)  # Add new nodes to OPEN
        if (not m.prev) or (g(m)>g(n)+distance(m, n)):
            m.prev = n
            g(m) = g(n) + distance(m, n)
        # This part is often not implemented because of its high expense
        # if m in CLOSED:
        #     redirect m's descendants
    
    # Sort nodes in open from lower cost to higher cost
    OPEN = sorted(OPEN, cmp=lambda x, y:f(x)-f(y))  
```

将A*算法用于下图的寻路问题

![route finding](/images/search/A*-route-finding.png)


g(x)数值即为从出发点到x的路径之和：$g(x)=\sum_{p=(n_0, n_1)}^{(n_m, x)}p$
h(x)数值为图右侧距离目标点的直线距离：$h(x)$

搜索过程如下：

![route finding](/images/search/A*-route-finding-tree.png)
