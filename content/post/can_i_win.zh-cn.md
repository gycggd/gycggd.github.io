---
title: "LeetCode 464. Can I Win"
date: 2018-04-16T14:55:46+08:00
tags:
    - Dynamic Programming
    - DFS
categories:
    - LeetCode
---

# Description

<div class="question-description"><div><p>In the "100 game," two players take turns adding, to a running total, any integer from 1..10. The player who first causes the running total to reach or exceed 100 wins. </p>

<p>What if we change the game so that players cannot re-use integers? </p>

<p>For example, two players might take turns drawing from a common pool of numbers of 1..15 without replacement until they reach a total &gt;= 100.</p>

<p>Given an integer <code>maxChoosableInteger</code> and another integer <code>desiredTotal</code>, determine if the first player to move can force a win, assuming both players play optimally. </p>

<p>You can always assume that <code>maxChoosableInteger</code> will not be larger than 20 and <code>desiredTotal</code> will not be larger than 300.
</p>

<p><b>Example</b>
</p><pre><b>Input:</b>
maxChoosableInteger = 10
desiredTotal = 11

<b>Output:</b>
false

<b>Explanation:</b>
No matter which integer the first player choose, the first player will lose.
The first player can choose an integer from 1 up to 10.
If the first player choose 1, the second player can only choose integers from 2 up to 10.
The second player will win by choosing 10 and get a total = 11, which is &gt;= desiredTotal.
Same with other integers chosen by the first player, the second player will always win.
</pre>
<p></p></div></div>

# Solution

小时候玩过这样的游戏，两个人轮流报1或者2，从0开始加上报的数字，先到达30的人获胜。玩多了发现一个规律，后报的人始终可以获胜，假设A，B两人，A先报数字，那么如果A报1，B就报2，反之A报2，B就报1，这样可以发现，所有3的倍数的数字都被B占了，所以B始终可以获胜。

这一题与之类似，不过多了个条件：每个数字只能使用一次。

那就多了一种情况，就是两个人都获胜不了，如果所有可以使用的数字之和小于target，这种情况作为特殊情况处理。

## 如果数字可以重复使用

现在先实现数字可以重复使用的情况：

令`dp[i]`表示玩家在当前和为i的情况下是否可以获胜。
choose表示玩家可以使用1~choose之间的数字。
target表示先到达target的玩家获胜。

初始情况：

`dp[i]=True if (i+choose)>=target`

递推公式：

`dp[i]=True if dp[i+j]=False for any i+1<=j<=i+choose`

返回结果:

`dp[0]`（即先选择的玩家是否获胜）

代码如下：

```
class Solution:
    def canIWin(self, choose, total):
        dp = [False]*(total+1)
        for i in range(total, -1, -1):
            if i+choose>=total:
                dp[i] = True
                continue
            for j in range(1, choose+1):
                if not dp[i+j]:
                    dp[i] = True
                    break
        return dp[0]
```

## 数字不可以重复使用

如果数字不可以重复使用的话，很直观的想法就是dfs进行回溯，新建一个数组保存每个数字的使用情况。

伪代码如下：

```
function dp(cur, used):
	for i in [1, choose]:
		# 如果i已经被使用，continue
		if used[i]:
			continue
		# 如果选择i可以超过total，获胜
		if cur+i>=total:
			return true
		# 选i，如果下一步对手在cur+i处不能获胜，则我方获胜
		used[i] = true
		tmp = dp(cur+i, used)
		used[i] = false
		if tmp:
			return true
	return false
```

实现之后可以发现TLE，问题在于有很多used数组相同的情况，很多重复计算。所以加上一个memory可以大幅减少时间。实现后代码如下：

```
class Solution:
    def canIWin(self, choose, total):
        if choose*(choose+1)/2<total:
            return False
        
        dp = [False]*total
        used = [False]*(choose+1)
        used[0] = True
        
        memo = {}
        def f(cur):
            key = str(used)
            if key in memo:
                return memo[key]
            else:
                for i in range(choose, 0, -1):
                    if not used[i]:
                        if cur+i>=total: 
                            memo[key] = True
                            return True
                        used[i] = True
                        tmp = f(cur+i)
                        used[i] = False
                        if not tmp: 
                            memo[key] = True
                            return True
                memo[key] = False
                return False
        
        return f(0)
```

耗时800ms左右。因为我们这里的memory每次都是把一个数组转化成字符串来作为dict的key的，非常耗时，而题目描述中choose不超过20，那么可以在这里进行改进，用一个数字，数字的第i位用来标记i是否被使用过，改进后Python代码如下：

```
class Solution:
    def canIWin(self, choose, total):
        if choose*(choose+1)/2<total: return False
        memo = {}
        def dp(cur, used):
            if used in memo:
                return memo[used]
            else:
                for i in range(choose, 0, -1):
                    if not used&(1<<i):
                        if cur+i>=total: 
                            memo[used] = True
                            return True
                        if not dp(cur+i, used|(1<<i)): 
                            memo[used] = True
                            return True
                memo[used] = False
                return False
        return dp(0, 0)
```

Java代码如下：

```
class Solution {
    
    public boolean canIWin(int choose, int total) {
        if (choose>=total)
            return true;
        if (choose*(choose+1)/2<total)
            return false;
        # 这里用一个Boolean的数组来做的memory，比map要快很多，但空间也用的多了
        Boolean memo[] = new Boolean[1<<(choose+1)];
        return dp(0, 0, choose, total, memo);
    }
    private boolean dp(int cur, int used, int choose, int total, Boolean[] memo) {
        if (memo[used]!=null) 
            return memo[used];
        for (int i=choose; i>0; i--) {
            if ((used&(1<<i))==0) {
                if (cur+i>=total) {
                    memo[used] = true;
                    return true;
                }
                if (!dp(cur+i, used|(1<<i), choose, total, memo)) {
                    memo[used] = true;
                    return true;
                }
            }
        }
        memo[used] = false;
        return false;
    }
}
```
