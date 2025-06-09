---
layout: post
status: publish
published: true
title: maven 如何为开发和生产环境建立不同的配置文件


date: '2015-12-25 14:44:10 +0800'
date_gmt: '2015-12-25 06:44:10 +0800'
categories:
- Opensource
tags:
- maven
- package
comments: []
---
`src/main`目录下原来有 `java`, `resources`, 新建环境相关的配置文件目录：

- resources : 一些共享的配置文件
- environment/dev : 开发环境下用的配置文件, 打包时会覆盖resources目录下的同名文件.
- environment/test : 测试环境下用的配置文件, 打包时会覆盖resources目录下的同名文件.
- environment/prod : 生产环境下用的配置文件, 打包时会覆盖resources目录下的同名文件.

本机开发时设置源码目录为 java, resources, 可直接开发调试.

编译的时候希望maven根据不同环境, 打包不同目录下的文件, 我们利用maven的profile和maven-resources-plugin插件来实现这个目标.

e.g. 运行 `mvn clean package -P test` 打包.


`pom.xml` 相关配置如下：

```xml
	<!-- == 配置开发/测试/生产环境 == -->
    <properties>
		<package.target>prod</package.target>
	</properties>

	<profiles>
		<profile>
			<id>dev</id>
			<properties>
				<package.target>dev</package.target>
			</properties>
		</profile>
		<profile>
			<id>test</id>
			<properties>
				<package.target>test</package.target>
			</properties>
		</profile>
		<profile>
			<id>prod</id>
			<properties>
				<package.target>prod</package.target>
			</properties>
		</profile>
	</profiles>

    <!-- == 使用maven-resources-plugin拷贝不同环境下的资源 == -->
	<build>
		<plugins>
			<plugin>
				<artifactId>maven-resources-plugin</artifactId>
				<version>2.5</version>
				<executions>
					<execution>
						<id>copy-resources</id>
						<phase>generate-resources</phase>
						<goals>
							<goal>copy-resources</goal>
						</goals>
						<configuration>
							<outputDirectory>target/classes</outputDirectory>
							<resources>
								<resource>
									<directory>src/main/environment/${package.target}</directory>
								</resource>
							</resources>
						</configuration>
					</execution>
				</executions>
			</plugin>
		</plugins>
	</build>
```
