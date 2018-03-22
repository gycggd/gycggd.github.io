---
title: "LeetCode 743. Network Delay Time"
date: 2018-03-22T23:00:35+08:00
tags:
    - DFS
    - BFS
    - Graph
categories:
    - Leetcode
---

![desc](/images/leetcode/743_1.png)

这题是一道用BFS或者DFS就可以解决的问题。

直接上代码:

```
class Solution:
    def networkDelayTime(self, times, N, K):
        """
        :type times: List[List[int]]
        :type N: int
        :type K: int
        :rtype: int
        """
        visited = {}
        l = [(K, 0)]
        
        # dic[i][j]表示从i到j的路径的耗时
        dic = {}
        for t in times:
            if t[0] in dic:
                dic[t[0]][t[1]] = t[2]
            else:
                dic[t[0]] = {t[1]:t[2]}
        
        # DFS
        while l:
            n, t = l.pop(0)
            # 如果当前耗时比之前的最小耗时还小，则更新
            visited[n] = t if n not in visited else min(t, visited[n])
            if n not in dic:
                continue
            tmp = dic[n]
            for k in tmp:
                # 如果没发送到这个节点或者存在更快路径，DFS之
                if k not in visited:
                    l.append((k, tmp[k]+t))
                elif visited[k]>tmp[k]+t:
                    l.append((k, tmp[k]+t))
                    
        # 检查是否能发送到所有节点
        if len(visited)!=N:
            return -1
        
        # 取耗时最久节点
        ret = -1
        for k in visited:
            ret = max(ret, visited[k])
        return ret

```

但是，只击败2%的Solution，可以优化成用heap每次扩展当前耗时最短的节点，这样可以省去很多不必要的扩展：

```
class Solution:
    def networkDelayTime(self, times, N, K):
        """
        :type times: List[List[int]]
        :type N: int
        :type K: int
        :rtype: int
        """

        cost = collections.defaultdict(dict)
        for i, j, t in times:
            cost[i][j] = t
        
        # path cost, idx, valid
        nodes = {_:[sys.maxsize, _, True] for _ in range(1, N+1)}
        nodes[K][0] = 0
        
        heap = [nodes[K]]
        
        while heap:
            # 每次取当前路径最短的来expand
            path, idx, valid = heapq.heappop(heap)
            if not valid:
                continue
            for succ in cost[idx]:
                # 如果优于当前路径，invalid之前的，更新新的短路径
                if path+cost[idx][succ]<nodes[succ][0]:
                    nodes[succ][2] = False
                    nodes[succ] = [path+cost[idx][succ], succ, True]
                    heapq.heappush(heap, nodes[succ])
        print(nodes)
        return max([nodes[_][0] for _ in nodes]) if max([nodes[_][0] for _ in nodes])!=sys.maxsize else -1
```