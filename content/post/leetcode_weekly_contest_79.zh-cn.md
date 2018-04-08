---
title: "Leetcode Weekly Contest 79"
date: 2018-04-08T13:03:16+08:00
tags:
    - Dynamic Programming
    - DFS
categories:
    - LeetCode
---

# 812. Largest Triangle Area

![desc](/images/leetcode/812_1.png)

直接三层循环用海伦公式计算即可

```
from math import sqrt
class Solution:
    def largestTriangleArea(self, points):
        dist = {}
        def d(p1, p2):
            return sqrt((p1[0]-p2[0])**2+(p1[1]-p2[1])**2)
        N = len(points)
        for i in range(N):
            for j in range(i+1, N):
                if i not in dist:
                    dist[i] = {}
                dist[i][j] = d(points[i], points[j])
        ret = 0
        for i in range(N):
            for j in range(i+1, N):
                for k in range(j+1, N):
                    p1, p2, p3 = dist[i][j], dist[j][k], dist[i][k]
                    p = (p1+p2+p3)/2
                    ret = max(ret, sqrt(max(p*(p-p1)*(p-p2)*(p-p3), 0)))
        return ret
```

# 813. Largest Sum of Averages

![desc](/images/leetcode/813_1.png)

用dp解决，dp(i, k)表示`A[i:]`的K个划分的最大average sum

初始状态：

`dp(i, 1) = avg(A[i:])`

递推公式：

`dp(i, k) = max(avg(A[i:j]), dp(j, k-1)) for j in range(i, len(A))`

返回：

`dp(0, k)`

```
class Solution:
    def largestSumOfAverages(self, A, K):
        N = len(A)
        ps = [0]*N
        for i in range(N):
            ps[i] = (ps[i-1] if i-1>=0 else 0)+A[i]
        def avg(i, j):
            x = (ps[j]-(ps[i-1] if i-1>=0 else 0))/(j-i+1)
            return x
        dic = {}
        def dp(i, k):
            if k==0: 
                return 0 if i==len(A) else -sys.maxsize
            if i+k>len(A): return -sys.maxsize
            if k==1: return avg(i, len(A)-1)
            if (i, k) not in dic:
                ret = -sys.maxsize
                for j in range(i, len(A)):
                    x = dp(j+1, k-1)
                    ret = max(ret, x+avg(i, j))
                dic[(i, k)] = ret
            return dic[(i, k)]
        return dp(0, K)
```

# 814. Binary Tree Pruning

![desc](/images/leetcode/814_1.png)

简单的dfs就可以了

```
class Solution:
    def pruneTree(self, root):
        def dfs(node):
            if not node: return False
            l, r = dfs(node.left), dfs(node.right)
            if not l: node.left = None
            if not r: node.right = None
            return (node.val==1) or l or r
        x = dfs(root)
        if not x:
            return None
        return root
```

# 815. Bus Routes

![desc](/images/leetcode/815_1.png)

一开始用站台来做bfs，遇到Time和Memory超过限制，用Bidirectional BFS还是TLE，然后用公交线路来做BFS通过。

```
class Solution:
    def numBusesToDestination(self, routes, S, T):
        if S==T: return 0
        nr = len(routes)
        routes = [set(_) for _ in routes]
        cross = [[False]*nr for _ in range(nr)]
        for i in range(nr):
            for j in range(i, nr):
                if i==j:
                    cross[i][j] = True
                else:
                    c = (len(routes[i]&routes[j])>0)
                    cross[i][j] = cross[j][i] = c
        dic = collections.defaultdict(set)
        for r in range(len(routes)):
            for i in routes[r]:
                dic[i].add(r)
        q = list(dic[S])
        dest = dic[T]
        visited = dic[S]
        cnt = 0
        while q:
            cnt += 1
            new_q = []
            for idx in q:
                if idx in dest:
                    return cnt
                for new_idx in range(nr):
                    if cross[idx][new_idx] and new_idx not in visited:
                        visited.add(new_idx)
                        new_q.append(new_idx)
            q = new_q
        return -1
```