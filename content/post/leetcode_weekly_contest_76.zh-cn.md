---
title: "Leetcode Weekly Contest 76"
date: 2018-03-18T12:53:17+08:00
tags:
    - BFS
    - Dynamic Programming
categories:
    - Leetcode
---

# 800. Similar RGB Color

![800 Description](/images/leetcode/800_1.png)

这题很容易，只需要将其分为3个部分，对每个部分找个最相近的 'XX' 格式的值即可。

对，每一个 'XY' 值，最近的一定在 'XX', '(X-1)(X-1)', '(X+1)(X+1)' 之中，所以我们计算出这三个值去最近的即可。

这是我5行的Python代码：
```
def similarRGB(self, color):
    ret = '#'
    for i in range(1, 6, 2):
        c1, c2 = [int(_) if '0'<=_<='9' else 10+ord(_)-ord('a') for _ in color[i:i+2]]
        c = c1+sorted(enumerate([abs((c1*16+c2)-(x*16+x)) for x in [c1-1, c1, c1+1]]), key=lambda _:_[1])[0][0]-1
        ret += str(c)*2 if c<=9 else chr(c-10+ord('a'))*2
    return ret
```


# 801. Minimum Swaps To Make Sequences Increasing

![801 Description](/images/leetcode/801_1.png)

以`1, 2, 3, 8, 5`和`5, 6, 7, 4, 9`为例，只需要交换`8`和`4`即可。

这个问题可以用动态规划来解决，在每一个位置可以有两种选择，交换和不交换，但是由于要产生两个排好序的数组，在确定之前的交换情况后，我们并不能自由选择交换与否。所以可以形成一个递推的公式：

初始化用来递推的数组dp，dp[i][0]和dp[i][1]表示在A[:i+1]与B[:i+1]上交换至有序需要的最少操作，其中dp[i][0]表示在i处不进行交换的情况，dp[i][1]表示在i处进行交换的情况。为什么要分成两个？因为在对下一个位置进行推导的时候，需要知道上一个位置的交换情况。
```
N = len(A)
dp = [[maxint]\*2 for \_ in range(N)]
```

推导公式如下：

For $i \in [1, N]$:

If A[i]>A[i-1] and B[i]>B[i-1]（不交换就有序）:
$$dp[i][0]=min(dp[i][0], dp[i-1][0])$$（i处不交换即可）
$$dp[i][1]=min(dp[i][1], dp[i-1][1]+1)$$（i-1处进行了交换，i处交换才可以保持有序）

If A[i]>B[i-1] and B[i]>A[i-1]（交换后有序）:
$$dp[i][0]=min(dp[i][0], dp[i-1][1])$$（由于i-1处已交换，不交换即有序）
$$dp[i][1]=min(dp[i][1], dp[i-1][0]+1)$$（i-1处未交换，i处交换可以有序）

上面两种情况并不冲突，所以取较小者

最后的结果是$min(dp[N-1][0], dp[N-1][1])$.

因为每次递推只需要用到前一次的结果，所以需要的空间是$O(1)$，时间是$O(N)$。

20行Python版Solution：

```
class Solution:
    def minSwap(self, A, B):
        """
        :type A: List[int]
        :type B: List[int]
        :rtype: int
        """
        n = len(A)
        pre = [0, 1]
        for i in range(1, n):
            cur = [sys.maxsize, sys.maxsize]
            if A[i]>A[i-1] and B[i]>B[i-1]:
                cur[0] = min(cur[0], pre[0])
                cur[1] = min(cur[1], pre[1]+1)
            if A[i]>B[i-1] and B[i]>A[i-1]:
                cur[0] = min(cur[0], pre[1])
                cur[1] = min(cur[1], pre[0]+1)
            pre = cur
        return min(pre)
```


# 802. Find Eventual Safe States

![802 Description](/images/leetcode/802_1.png)

这一题其实就是找出所有有任何路径进入循环的节点。

我在contest的时候的做法是找出所有循环中的所有节点，然后再找出所有有路径通往这些节点的节点即可。虽然复杂但也Accept了。

800ms的解法：

```
def eventualSafeNodes(self, graph):
    """
    :type graph: List[List[int]]
    :rtype: List[int]
    """
    n = len(graph)
    ret = set(range(n))
    visited = set()
    path = set()
    for i in range(n):
        if i in visited:
            continue
        st = [(i, False)]
        while st:
            n, v = st.pop()
            visited.add(n)
            if v:
                path.remove(n)
                continue
            st.append((n, True))
            path.add(n)
            for nn in graph[n]:
                if nn in path:
                    idx = len(st)-1
                    while idx>=0:
                        if st[idx][1] and st[idx][0] in ret:
                            ret.remove(st[idx][0])
                        idx -= 1
                    continue
                if nn not in ret:
                    idx = len(st)-1
                    while idx>=0:
                        if st[idx][1] and st[idx][0] in ret:
                            ret.remove(st[idx][0])
                        idx -= 1
                    continue
                if nn in visited:
                    continue
                st.append((nn, False))
    n = len(graph)
    while True:
        pre = len(ret)
        for i in range(n):
            if i not in ret:
                continue
            for j in graph[i]:
                if j not in ret:
                    ret.remove(i)
                    break
        if len(ret)==pre:
            break
    return list(ret)
```

其实我们可以从出度为0的节点开始，每次都删除出度为0的节点，删除掉的节点即是结果。

1. 找到所有出度为0的节点，从图中删除并加入到结果
2. 由于1中删除了一些节点，会有一些新的节点出度为0，把这些节点删除并加入结果
3. 重复2直到没有节点可以删除

300ms Solution：
```
def eventualSafeNodes(self, graph):
    """
    :type graph: List[List[int]]
    :rtype: List[int]
    """
    n = len(graph)
    out_degree = collections.defaultdict(int)
    in_nodes = collections.defaultdict(list) 
    queue = []
    ret = []
    for i in range(n):
        out_degree[i] = len(graph[i])
        if out_degree[i]==0:
            queue.append(i)
        for j in graph[i]:
            in_nodes[j].append(i)  
    while queue:
        term_node = queue.pop(0)
        ret.append(term_node)
        for in_node in in_nodes[term_node]:
            out_degree[in_node] -= 1
            if out_degree[in_node]==0:
                queue.append(in_node)
    return sorted(ret)
```


# 803. Bricks Falling When Hit

![803 Description](/images/leetcode/803_1.png)

直接的做法是对每一次hit计算有多少不会掉落的砖块然后返回每次的差值。但我尝试之后发现会TLE，因为每次hit都对所有顶层的砖块进行一遍DFS耗时太多，只能采取效率更高的解法。

反过来看这个问题的话，其实是从所有hits之后的状态，从最后一个hit开始，往墙上贴砖块，那么每次增加的不会掉落的砖块也就是这个hit之后掉落的砖块数目。

Let m, n = len(grid), len(grid[0]).

1. For each hit (i, j), if grid[i][j]==0, set grid[i][j]=-1 otherwise set grid[i][j]=0. Since a hit may happen at an empty position, we need to seperate emptys from bricks.
2. For i in [0, n], do dfs at grid[i][0] and mark no-dropping bricks. Here we get the grid after all hits.
3. Then for each hit (i,j) (reversely), first we check grid[i][j]==-1, if yes, it's empty, skip this hit. Then we check whether it's connected to any no-dropping bricks or it's at the top, if not, it can't add any no-dropping bricks, skip this hit. Otherwise we do dfs at grid[i][j], mark new added no-dropping bricks and record amount of them.
4. Return the amounts of new added no-dropping bricks at each hits.

用这种方法，只需要进行$O(n)+O(len(hits))$次DFS.

代码如下：

```
class Solution:
    def hitBricks(self, grid, hits):
        """
        :type grid: List[List[int]]
        :type hits: List[List[int]]
        :rtype: List[int]
        """

        m, n = len(grid), len(grid[0])
        
        # Connect unconnected bricks and 
        def dfs(i, j):
            if not (0<=i<m and 0<=j<n) or grid[i][j]!=1:
                return 0
            ret = 1
            grid[i][j] = 2
            ret += dfs(i-1, j)
            ret += dfs(i+1, j)
            ret += dfs(i, j-1)
            ret += dfs(i, j+1)
            return ret
        
        # Check whether (i, j) is connected to Not Falling Bricks
        def is_connected(i, j):
            ret = False
            ret |= (h[0]-1>=0 and grid[h[0]-1][h[1]]==2)
            ret |= (h[0]+1<m and grid[h[0]+1][h[1]]==2)
            ret |= (h[1]-1>=0 and grid[h[0]][h[1]-1]==2)
            ret |= (h[1]+1<n and grid[h[0]][h[1]+1]==2)
            ret |= (h[0]==0)
            return ret
        
        # Mark whether there is a brick at the each hit
        for h in hits:
            if grid[h[0]][h[1]]==1:
                grid[h[0]][h[1]] = 0
            else:
                grid[h[0]][h[1]] = -1
                
        # Get grid after all hits
        for i in range(n):
            dfs(0, i)
        
        # Reversely add the block of each hits and get count of newly add bricks
        ret = [0]*len(hits)
        for i in reversed(range(len(hits))):
            h = hits[i]
            if grid[h[0]][h[1]]==-1:
                continue
            grid[h[0]][h[1]] = 1
            if not is_connected(h[0], h[1]):
                continue
            ret[i] = dfs(h[0], h[1])-1
            
        return ret
```
