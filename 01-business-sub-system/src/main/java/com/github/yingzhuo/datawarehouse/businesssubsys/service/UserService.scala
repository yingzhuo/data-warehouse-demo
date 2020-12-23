package com.github.yingzhuo.datawarehouse.businesssubsys.service

trait UserService {

  def login(username: String, password: String): Boolean

  def logout(username: String): Boolean

}
