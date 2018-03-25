---
title: "Leetcode Weekly Contest 76"
date: 2018-03-18T12:53:17+08:00
tags:
    - BFS
    - Dynamic Programming
    - Graph
categories:
    - Leetcode
---

# 800. Similar RGB Color

![800 Description](/images/leetcode/800_1.png)

This is so easy, just split into 3 parts, and for each part find the closest 'XX' format value.

For 'XY', the closes must be among 'XX', '(X-1)(X-1)', '(X+1)(X+1)', so check them all and choose cloest.

My 5-line code here:
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

Take `1, 2, 3, 8, 5`和`5, 6, 7, 4, 9` for example，we only need to swap `8` and `4`.

This problem can be solved using dynamic programming, at each position, we can choose to swap or not. Since we want two sorted arrays, at each position, whether to swap or not depends on the choice at previous position, so we can form a recursive formula.

```
N = len(A)
dp = [[maxint]\*2 for \_ in range(N)]
```

Let initialize a N\*2 array dp, 

* dp[i][0] means the least swaps used to make A[:i+1] and B[:i+1] sorted having no swap at i-th position.
* dp[i][1] means the least swaps used to make A[:i+1] and B[:i+1] sorted having swap at i-th position.

Here is the recursive formula:

For $i \in [1, N]$:

If A[i]>A[i-1] and B[i]>B[i-1] (they are in order without swap):
$$dp[i][0]=min(dp[i][0], dp[i-1][0])$$ (no swap at i-1 and no swap at i)
$$dp[i][1]=min(dp[i][1], dp[i-1][1]+1)$$ (swap at i-1 so swap at i to make in order)

If A[i]>B[i-1] and B[i]>A[i-1] (they are in order with a swap):
$$dp[i][0]=min(dp[i][0], dp[i-1][1])$$ (swap at i-1, no need to swap at i)
$$dp[i][1]=min(dp[i][1], dp[i-1][0]+1)$$ (no swap at i-1, so swap at i)

The two cases don't conflict with each other, so we choose minimum of them when both holds.

What we want to return is $min(dp[N-1][0], dp[N-1][1])$.

At every recursion, we only need the last result, so we can use less space, from $O(N)$ to $O(1)$, time complexity $O(N)$.

20-Line Python Solution：

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

This is equal to find nodes which doesn't lead to a circle in any path.

My AC soluction during contest finds all nodes in circles, and then remove nodes connected to circle nodes until no more nodes can be removed. Here is my 800ms verbose code:

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

After the contest, I found we can solve it by walk along the path reversely.

1. Find nodes with out degree 0, they are terminal nodes, we remove them from graph and they are added to result
2. For nodes who are connected terminal nodes, since terminal nodes are removed, we decrease in-nodes' out degree by 1 and if its out degree equals to 0, it become new terminal nodes
3. Repeat 2 until no terminal nodes can be found.

Here is my 300ms 20-line Python Code:

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

A straight-forward solution is to count no-dropping bricks after each hit and return the difference.

I did it during contest and of course got TLE because it does dfs from all bricks at the top for every hit.

So how to decrease dfs processes? We can reverse the problem and count how many new no-dropping bricks are added when we add the bricks reversely. It's just the same of counting dropping bricks when erase one brick.

Let m, n = len(grid), len(grid[0]).

Here is the detailed solution:

1. For each hit (i, j), if grid[i][j]==0, set grid[i][j]=-1 otherwise set grid[i][j]=0. Since a hit may happen at an empty position, we need to seperate emptys from bricks.
2. For i in [0, n], do dfs at grid[i][0] and mark no-dropping bricks. Here we get the grid after all hits.
3. Then for each hit (i,j) (reversely), first we check grid[i][j]==-1, if yes, it's empty, skip this hit. Then we check whether it's connected to any no-dropping bricks or it's at the top, if not, it can't add any no-dropping bricks, skip this hit. Otherwise we do dfs at grid[i][j], mark new added no-dropping bricks and record amount of them.
4. Return the amounts of new added no-dropping bricks at each hits.

Using this method, we only do $O(n)+O(len(hits))$ dfs.

Here is an example：
![803 Description](/images/leetcode/803_2.png)
![803 Description](/images/leetcode/803_3.png)
![803 Description](/images/leetcode/803_4.png)
![803 Description](/images/leetcode/803_5.png)
![803 Description](/images/leetcode/803_6.png)

Code here：

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
            ret += sum(dfs(x, y) for x, y in [(i-1, j), (i+1, j), (i, j-1), (i, j+1)])
            return ret
        
        # Check whether (i, j) is connected to Not Falling Bricks
        def is_connected(i, j):
            return i==0 or any([0<=x<m and 0<=y<n and grid[x][y]==2 for x, y in [(i-1, j), (i+1, j), (i, j-1), (i, j+1)]])
        
        # Mark whether there is a brick at the each hit
        for i, j in hits:
            grid[i][j] -= 1
                
        # Get grid after all hits
        for i in range(n):
            dfs(0, i)
        
        # Reversely add the block of each hits and get count of newly add bricks
        ret = [0]*len(hits)
        for k in reversed(range(len(hits))):
            i, j = hits[k]
            grid[i][j] += 1
            if grid[i][j]==1 and is_connected(i, j):
                ret[k] = dfs(i, j)-1
            
        return ret
```
