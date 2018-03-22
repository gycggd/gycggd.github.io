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