#一、Git入门简介

##1、Git是目前世界上最先进的分布式版本控制系统

什么是版本控制系统？

* 能够记录文档的改动历史
* 能够回滚到任意一个修改时间点
* 能够协作编辑文件



## 2、Git部署范围

Git可在Linux、Unix、Mac和Windows多种平台部署



## 3、Git的安装

``` shell
1）安装git服务
[root@localhost data1]# yum install git
要通过源码来安装，先从Git官网（https://git-scm.com/）下载源码，然后解压，依次输入：./config，make，make install 即可

2）创建git目录
[root@localhost data1]# mkdir gitlearn

3）通过git init命令把这个目录变成Git可以管理的版本仓库：
[root@localhost data1]# cd gitlearn/
[root@localhost gitlearn]# pwd
/data1/gitlearn
[root@localhost gitlearn]# git init
Initialized empty Git repository in /data1/gitlearn/.git/
初始化空的 Git 版本库于 /data1/gitlearn/.git/，这目录是Git来跟踪管理版本库的，千万不要手动修改这个目录里面的文件，否则会把Git仓库给破坏

[root@localhost gitlearn]# ls -al
total 0
drwxr-xr-x  3 root root  18 May 11 11:28 .
drwxr-xr-x. 5 root root  52 May 11 11:14 ..
drwxr-xr-x  7 root root 119 May 11 11:28 .git
```



## 4、把文件添加到版本库

~~~ shell
编写一个readme.txt文件，内容如下：
Git is a version control system.
Git is free software.

[root@localhost gitlearn]# cat > /data1/gitlearn/readme.txt <<EOF
> Git is a version control system.
> Git is free software.
> EOF
[root@localhost gitlearn]# ll
total 4
-rw-r--r-- 1 root root 55 May 11 11:35 readme.txt

用命令git add告诉Git，把文件添加到版本库：
[root@localhost gitlearn]# git add readme.txt

用命令git commit告诉Git，把文件提交到版本库：
[root@localhost gitlearn]# git commit -m "add readme.txt"
[master (root-commit) 406cf85] add readme.txt
 Committer: root <root@localhost.localdomain>
Your name and email address were configured automatically based
on your username and hostname. Please check that they are accurate.
You can suppress this message by setting them explicitly:

    git config --global user.name "Your Name"
    git config --global user.email you@example.com

After doing this, you may fix the identity used for this commit with:

    git commit --amend --reset-author

 1 file changed, 2 insertions(+)
 create mode 100644 readme.txt

批量添加文件后提交
[root@localhost gitlearn]# cp /etc/hosts .
[root@localhost gitlearn]# cp /etc/resolv.conf .
[root@localhost gitlearn]# ll
total 12
-rw-r--r-- 1 root root 159 May 11 15:07 hosts
-rw-r--r-- 1 root root  73 May 11 15:01 readme.txt
-rw-r--r-- 1 root root  81 May 11 15:07 resolv.conf
[root@localhost gitlearn]# 
[root@localhost gitlearn]# git add hosts resolv.conf
[root@localhost gitlearn]# git commit -m "add 2 files"
[master 342c0bb] add 2 files
 2 files changed, 6 insertions(+)
 create mode 100644 hosts
 create mode 100644 resolv.conf
~~~



## 5、Git版本回退、文件修改、撤销与删除

（1）查看git工作区状态

~~~ shell
修改文件后，未加入提交状态：
[root@localhost gitlearn]# git status
# On branch master
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#
#	modified:   readme.txt
#
no changes added to commit (use "git add" and/or "git commit -a")
解析：
# 位于分支 master
# 尚未暂存以备提交的变更：
#   （使用 "git add <file>..." 更新要提交的内容）
#   （使用 "git checkout -- <file>..." 丢弃工作区的改动）
#
#       修改：      readme.txt
#
修改尚未加入提交（使用 "git add" 和/或 "git commit -a"）

修改文件后，git add 状态，反馈文件状态未“to unstage（暂存区）”：
[root@localhost gitlearn]# git add readme.txt
[root@localhost gitlearn]# git status
# On branch master
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#	modified:   readme.txt
解析：
# 位于分支 master
# 提交变更：
#   （使用 "git add <file>..." 撤出暂存区）
#
#       修改：      readme.txt

修改文件后，git commit 状态，反馈文件状态完成，工作区干净
[root@localhost gitlearn]# git commit -m "read-3"
[master 2713030] read-3
 1 file changed, 6 insertions(+), 1 deletion(-)
解析：
# 位于分支 master
此时无文件要提交，干净的工作区，注意commit -m 中不能添加特殊字符

~~~

（2）查看具体修改了什么内容，用git diff查看

~~~shell 
修改内容后，暂不提交，执行git diff 命令，查看修改的具体内容，---表示修改前内容；+++表示修改后内容
[root@localhost gitlearn]# git diff readme.txt
diff --git a/readme.txt b/readme.txt
index e7700fd..b95d71f 100644
--- a/readme.txt
+++ b/readme.txt
@@ -1,4 +1,7 @@
 Git is a version control system.
 Git is powerful software.
 
-It Work!
+I
+t
+Work!
+OK
~~~

（3）版本回退

~~~ shell
修改内容并提交
[root@localhost gitlearn]# cat readme.txt 
Git is a version control system.
Git is powerful software distributed under the GPL.

I
t
Work!
OK

test0000001
[root@localhost gitlearn]# git add readme.txt
[root@localhost gitlearn]# git commit -m "add GPL"
[master 3ed9e5d] add GPL
 1 file changed, 1 insertion(+), 1 deletion(-)

查看版本修改历史，用git log命令，反馈历史版本信息
[root@localhost gitlearn]# git log 
commit 3ed9e5d49f0b9da16eb938963815fbf2f647429c  #commit 为版本号，回退时可以直接输入版本号前7、8位来快速回退至指定版本
Author: liuxc083 <liuxc083@163.com>
Date:   Tue May 11 15:28:37 2021 +0800

    add GPL

commit 27130305465344da85eb80e8e5f30193e7e8e48b
Author: liuxc083 <liuxc083@163.com>
Date:   Tue May 11 15:16:06 2021 +0800

    read-3

commit 342c0bbb2f3c5e4153456965da439f1992f42ef1
Author: liuxc083 <liuxc083@163.com>
Date:   Tue May 11 15:08:01 2021 +0800

    add 2 files

commit a668d002bf37900df6e357a539cbffb514e92d7d
Author: liuxc083 <liuxc083@163.com>
Date:   Tue May 11 15:01:13 2021 +0800

    readme-01.txt

commit 406cf85b84be313ca2eab80bc3822b5532725f64
Author: root <root@localhost.localdomain>
Date:   Tue May 11 14:13:51 2021 +0800

    add readme.txt

在Git中，用HEAD表示当前版本，也就是上图中提交“3ed9e5d...”，上一个版本用HEAD^表示，上上一个版本用HEAD^^表示，若往上100个版本表示为HEAD~100

回退至上一个版本，用git reset 命令：
[root@localhost gitlearn]# git reset --hard HEAD^
HEAD is now at 2713030 read-3  

Git可以在所有提交的版本中穿越操作（即可以回退旧版本，也可以从旧版本中的穿越到未来版本，但前提需要执行了多次版本提交），用git reflog查看命令历史，以确定要穿越到哪个版本
[root@localhost gitlearn]# git reflog
2713030 HEAD@{0}: reset: moving to HEAD^
3ed9e5d HEAD@{1}: commit: add GPL
2713030 HEAD@{2}: commit: read-3
342c0bb HEAD@{3}: commit: add 2 files
a668d00 HEAD@{4}: commit: readme-01.txt
406cf85 HEAD@{5}: commit (initial): add readme.txt

[root@localhost gitlearn]# git reset --hard a668d00
HEAD is now at a668d00 readme-01.txt

[root@localhost gitlearn]# git log 
commit a668d002bf37900df6e357a539cbffb514e92d7d
Author: liuxc083 <liuxc083@163.com>
Date:   Tue May 11 15:01:13 2021 +0800

    readme-01.txt

commit 406cf85b84be313ca2eab80bc3822b5532725f64
Author: root <root@localhost.localdomain>
Date:   Tue May 11 14:13:51 2021 +0800

    add readme.tx

~~~



***

**概念梳理：**

**前面把文件往Git版本库里添加的时候，是分两步执行的：**

**第一步执行git add把文件添加进去，实际上就是把文件修改添加到暂存区；**

**第二步执行git commit提交更改，实际上就是把暂存区的所有内容提交到当前分支。**

**可以简单理解为，需要提交的文件修改放到暂存区，然后，一次性提交暂存区的所有修改。**



**另外，在Git管理中，管理的是修改操作，而不是管理文件本身。**

*当用git add命令后，在工作区的第一次修改被放入暂存区，准备提交，但如果在工作区的第二次修改没有放入暂存区，那么，git commit只负责把暂存区的修改提交了，也就是第一次的修改被提交，第二次的修改不会被提交。*

~~~shell
[root@localhost gitlearn]# vim readme.txt 
Git is a version control system.
Git is powerful software.

It Work!
git hello  #第一次修改

[root@localhost gitlearn]# git add readme.txt  #第一次添加至缓存区
[root@localhost gitlearn]# vim readme.txt 
Git is a version control system.
Git is powerful software.

It Work!
git hello
git 12345  #第二次修改

[root@localhost gitlearn]# git commit -m "add hello"  #此时，提交的第一次修改
[master a80dc30] add hello
 1 file changed, 1 insertion(+)
[root@localhost gitlearn]# git status
# On branch master
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#
#	modified:   readme.txt
#
no changes added to commit (use "git add" and/or "git commit -a")
以上状态：提示有内容为提交至缓存区
对比此时的修改
[root@localhost gitlearn]# git diff HEAD -- readme.txt
diff --git a/readme.txt b/readme.txt
index d18da3d..ad59a16 100644
--- a/readme.txt
+++ b/readme.txt
@@ -3,3 +3,4 @@ Git is powerful software.
 
 It Work!
 git hello  #第一次修改内容，已提交
+git 12345  #第二次修改内容，未提交
以上证明了，Git 管理的是修改操作而不是文件本身
建议，工作中多次修改内容，一次add 添加 并commit 提交
~~~

***



（4）版本撤销

git有撤销修改的功能，主要执行git checkout -- file命令丢弃工作区的修改

**版本撤销，分三类情况：**

* 修改后还未添加至暂存区，撤销修改就回到和版本库一模一样的状态，执行命令git checkout -- file
* 已经添加到暂存区，先执行git reset HEAD file 撤销修改，回到添加到暂存区后的状态；再执行git checkout -- file 返回至修改前状态


* 已经添加并且提交至分支，执行版本回退操作

~~~shell
修改后还未添加至暂存区：
[root@localhost gitlearn]# vim readme.txt 
Git is a version control system.
Git is powerful software.

It Work!
git hello
git 12345

zxcvadjvlkzjclkvja;;zlkjga
                                                         
[root@localhost gitlearn]# git status 
# On branch master
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#
#	modified:   readme.txt
#
no changes added to commit (use "git add" and/or "git commit -a")

[root@localhost gitlearn]# git checkout -- readme.txt 
[root@localhost gitlearn]# more readme.txt 
Git is a version control system.
Git is powerful software.

It Work!
git hello
git 12345

~~~

~~~shell
已经添加到暂存区：
[root@localhost gitlearn]# vim readme.txt 
Git is a version control system.
Git is powerful software.

It Work!
git hello
git 12345

ELXJCIOALKGJ';
';OZDKJ

[root@localhost gitlearn]# git add readme.txt
[root@localhost gitlearn]# git status
# On branch master
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#	modified:   readme.txt
#

[root@localhost gitlearn]# git reset HEAD readme.txt
Unstaged changes after reset:
M	readme.txt
[root@localhost gitlearn]# git status
# On branch master
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#
#	modified:   readme.txt
#
no changes added to commit (use "git add" and/or "git commit -a")
[root@localhost gitlearn]# cat readme.txt 
Git is a version control system.
Git is powerful software.

It Work!
git hello
git 12345

ELXJCIOALKGJ';
';OZDKJ 

[root@localhost gitlearn]# git checkout -- readme.txt
[root@localhost gitlearn]# cat readme.txt 
Git is a version control system.
Git is powerful software.

It Work!
git hello
git 12345
~~~



（4）删除git文件

如果一个文件已经被提交到版本库，那么永远不用担心误删，但是要小心，只能恢复文件到最新版本，也就是说你会丢失其它版本内容。

~~~shell
执行系统删除命令rm -rf
[root@localhost gitlearn]# rm -rf hosts
[root@localhost gitlearn]# git status
# On branch master
# Changes not staged for commit:
#   (use "git add/rm <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#
#	deleted:    hosts
#
no changes added to commit (use "git add" and/or "git commit -a")

彻底删除还需要执行git rm 和 git commit操作 
[root@localhost gitlearn]# git rm hosts
rm 'hosts'
[root@localhost gitlearn]# git status
# On branch master
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#	deleted:    hosts
#
[root@localhost gitlearn]# git commit -m "del hosts"
[master acba429] del hosts
 1 file changed, 3 deletions(-)
 delete mode 100644 hosts
[root@localhost gitlearn]# git status
# On branch master
nothing to commit, working directory clean


误删除的恢复
[root@localhost gitlearn]# rm -rf readme.txt 
[root@localhost gitlearn]# git status 
# On branch master
# Changes not staged for commit:
#   (use "git add/rm <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#
#	deleted:    readme.txt
#
no changes added to commit (use "git add" and/or "git commit -a")
[root@localhost gitlearn]# 
[root@localhost gitlearn]# git checkout -- readme.txt

~~~



# 二、Git远程仓库-github入门简介

Git是分布式版本控制系统，同一个Git仓库，可以分布到不同的机器上。最早，肯定只有一台机器有一个原始版本库，此后，别的机器可以“克隆”这个原始版本库，而且每台机器的版本库其实都是一样的，并没有主次之分。

GitHub网站：https://github.com/；注册GitHub账号，就可以免费获得Git远程仓库。

由于本地Git仓库和GitHub仓库之间的传输是通过SSH加密的，所以需要设置公钥认证机制；GitHub允许添加多个Key。假定你有若干电脑，一会儿在公司提交，一会儿在家里提交，只要把每台电脑的Key都添加到GitHub，就可以在每台电脑上往GitHub推送内容。

友情提示：在GitHub上免费托管的Git仓库，任何人都可以看到喔（但只有你自己才能改）。不要把敏感信息放进去。如果你不想让别人看到Git库，有两个办法，让GitHub把公开的仓库变成私有的。另一个办法是自己动手，搭一个Git服务器。

### 1、本地服务器创建密钥对，将公钥传送至github

![ssh-keygen](F:\BaiduNetdiskDownload\Typora\笔记\git\ssh-keygen.png)

![ssh-keygen](F:\BaiduNetdiskDownload\Typora\笔记\git\id_rsa.pub.png)



![github-ssh](F:\BaiduNetdiskDownload\Typora\笔记\git\github-ssh.png)



### 2、在github上创建远程仓库

![创建远程仓库](F:\BaiduNetdiskDownload\Typora\笔记\git\创建远程仓库.png)



### 3、将本地仓库与远程仓库关联，实现本地编辑代码并远程保存

~~~shell
[root@localhost gitlearn]# git remote add origin git@github.com:liuxc083/gitlearn.git
[root@localhost gitlearn]# git branch -M main

上传本地仓库版本至远程仓库
[root@localhost gitlearn]# git push -u origin main
Counting objects: 16, done.
Delta compression using up to 2 threads.
Compressing objects: 100% (12/12), done.
Writing objects: 100% (16/16), 1.34 KiB | 0 bytes/s, done.
Total 16 (delta 2), reused 0 (delta 0)
remote: Resolving deltas: 100% (2/2), done.
To git@github.com:liuxc083/gitlearn.git
 * [new branch]      main -> main
Branch main set up to track remote branch main from origin.

~~~

![完成上传的远程仓库](F:\BaiduNetdiskDownload\Typora\笔记\git\完成上传的远程仓库.png)



示例：将写好的脚本上传至远程仓库

~~~shell
[root@localhost gitlearn]# cp /root/first-work.sh .
[root@localhost gitlearn]# ls
first-work.sh  hosts  readme.txt  resolv.conf

[root@localhost gitlearn]# git add first-work.sh
[root@localhost gitlearn]# git commit -m "add first-work.sh"
[main 549dda0] add first-work.sh
 1 file changed, 25 insertions(+)
 create mode 100755 first-work.sh

[root@localhost gitlearn]# git push origin main
Warning: Permanently added the RSA host key for IP address '13.229.188.59' to the list of known hosts.
Counting objects: 4, done.
Delta compression using up to 2 threads.
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 765 bytes | 0 bytes/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To git@github.com:liuxc083/gitlearn.git
   935ce10..549dda0  main -> main
~~~

**注意：若远程库是空的，第一次推送master分支时，加上了-u参数，Git不但会把本地的master分支内容推送的远程新的master分支，还会把本地的master分支和远程的master分支关联起来，在以后的推送或者拉取时就可不加-u参数。**

### 4、从远程仓库克隆至本地

![克隆地址](F:\BaiduNetdiskDownload\Typora\笔记\git\克隆地址.jpg)

克隆远程仓库至本地，注意不能在之前的本地仓库中执行该操作。

~~~shell
[root@localhost data1]# git clone git@github.com:liuxc083/gitl-clone1.git
Cloning into 'gitl-clone1'...
remote: Enumerating objects: 3, done.
remote: Counting objects: 100% (3/3), done.
remote: Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
Receiving objects: 100% (3/3), done.
[root@localhost data1]# ll
total 0
drwxr-xr-x  3 root root  46 Mar 24 16:56 docker-app
drwxr-xr-x  3 root root  35 May 12 15:58 gitl-clone1
drwxr-xr-x  3 root root  89 May 12 15:40 gitlearn
drwxr-xr-x 12 root root 144 Apr  9 17:29 test

~~~



这里注意报错：

~~~shell
[root@localhost gitl-clone1]# vim README.md 
# gitl-clone1
hello!
[root@localhost gitl-clone1]# git add README.md 
[root@localhost gitl-clone1]# git commit -m "add hello"
[main 0347e91] add hello
 1 file changed, 2 insertions(+), 1 deletion(-)
[root@localhost gitl-clone1]# git push origin master
error: src refspec master does not match any.   ###这里提示没有master这个分支
error: failed to push some refs to 'git@github.com:liuxc083/gitl-clone1.git'

~~~

![提交报错-分支名称](F:\BaiduNetdiskDownload\Typora\笔记\git\提交报错-分支名称.png)

这里查看了远程仓库没有master分支，只有main主分支。后面介绍分支的概念

~~~shell
[root@localhost gitl-clone1]# git push origin main
Counting objects: 5, done.
Writing objects: 100% (3/3), 254 bytes | 0 bytes/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To git@github.com:liuxc083/gitl-clone1.git
   fe107f8..0347e91  main -> main
~~~



**注意：Git支持多种协议，github也支持3类接口，满足不同需求**

![github不同的接口](F:\BaiduNetdiskDownload\Typora\笔记\git\github不同的接口.jpg)



#三、Git分支与标签管理

概念：创建自己的分支，不影响他人的活儿，完成本分支工作后，在主分支上合并提交。



创建并切换至新的分支
语法：
git checkout -b（创建并切换至新分支） 分支名称

~~~shell
[root@localhost gitlearn]# git checkout -b ops_dev
Switched to a new branch 'ops_dev'

~~~

切换分支
git checkout 分支名称



查看分支
git branch

~~~shell 
[root@localhost gitlearn]# git branch
  main
* ops_dev

~~~

合并分支
git merge 分支名称
注意，在主分支上合并之前创建的分支



删除分支
git branch -d dev



**小结：**
-b <new_branch>  Create a new branch named <new_branch> and start it at <start_point>; 

**表示创建新分支**

**-d 参数 表示删除分支**

