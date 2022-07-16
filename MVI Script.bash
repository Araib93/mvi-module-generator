#!/bin/bash

#region Reading inputs
# Reading package name
read -p "Enter package name: " package_name
# package_name="com.example.app"

# Reading domain name
read -p "Enter domain name: " domain_name
#endregion

# Reading base creation
make_base=false
while true; do
    read -p "Create base methods (y/n): " yn
    case $yn in
        [Yy]* ) make_base=true; break;;
        [Nn]* ) make_base=false; break;;
        * ) echo "Please input y/n: ";;
    esac
done


#region Process inputs
# Capitalizing domain name
domain_name_caps="$(tr '[:lower:]' '[:upper:]' <<< ${domain_name:0:1})${domain_name:1}"
#endregion

#region Setting up
# Setting up herarichy
mkdir -p ~/$domain_name

# Setting up data folders
mkdir -p ~/$domain_name/data
mkdir -p ~/$domain_name/data/local
mkdir -p ~/$domain_name/data/local/dao
mkdir -p ~/$domain_name/data/local/dto
mkdir -p ~/$domain_name/data/remote
mkdir -p ~/$domain_name/data/remote/api
mkdir -p ~/$domain_name/data/remote/dto

# Setting up di folders
mkdir -p ~/$domain_name/di

# Setting up domain folders
mkdir -p ~/$domain_name/domain
mkdir -p ~/$domain_name/domain/usecase

# Setting up ui folders
mkdir -p ~/$domain_name/ui
mkdir -p ~/$domain_name/ui/uistate
mkdir -p ~/$domain_name/ui/viewmodel
#endregion

#region Creating files
# Creating data files
touch ~/$domain_name/data/"$domain_name_caps"Repository.kt
touch ~/$domain_name/data/"$domain_name_caps"RepositoryImpl.kt

# Creating local data source files
touch ~/$domain_name/data/local/"$domain_name_caps"LocalDataSource.kt
touch ~/$domain_name/data/local/"$domain_name_caps"LocalDataSourceImpl.kt
touch ~/$domain_name/data/local/dao/"$domain_name_caps"Dao.kt
touch ~/$domain_name/data/local/dto/"$domain_name_caps"Dto.kt

# Creating remote data source files
touch ~/$domain_name/data/remote/"$domain_name_caps"RemoteDataSource.kt
touch ~/$domain_name/data/remote/"$domain_name_caps"RemoteDataSourceImpl.kt
touch ~/$domain_name/data/remote/api/"$domain_name_caps"Api.kt
touch ~/$domain_name/data/remote/dto/"$domain_name_caps"Dto.kt

# Creating di files
touch ~/$domain_name/di/"$domain_name_caps"Module.kt

# Creating domain files
touch ~/$domain_name/domain/"$domain_name_caps"Entity.kt
touch ~/$domain_name/domain/usecase/ObserveAll"$domain_name_caps"UseCase.kt
touch ~/$domain_name/domain/usecase/GetAll"$domain_name_caps"UseCase.kt
touch ~/$domain_name/domain/usecase/Observe"$domain_name_caps"ByIdUseCase.kt
touch ~/$domain_name/domain/usecase/Get"$domain_name_caps"ByIdUseCase.kt
touch ~/$domain_name/domain/usecase/Clear"$domain_name_caps"UseCase.kt

# Creating ui files
touch ~/$domain_name/ui/"$domain_name_caps"Composables.kt
touch ~/$domain_name/ui/viewmodel/"$domain_name_caps"ViewModel.kt
#endregion

#region Writing code
# Writing code for data files
printf "package $package_name.$domain_name.data

interface "$domain_name_caps"Repository
" > ~/$domain_name/data/"$domain_name_caps"Repository.kt
printf "package $package_name.$domain_name.data

import $package_name.$domain_name.data.local."$domain_name_caps"LocalDataSource
import $package_name.$domain_name.data.remote."$domain_name_caps"RemoteDataSource
import javax.inject.Inject

class "$domain_name_caps"RepositoryImpl @Inject constructor(
    private val localDataSource: "$domain_name_caps"LocalDataSource,
    private val remoteDataSource: "$domain_name_caps"RemoteDataSource
) : "$domain_name_caps"Repository {
    fun observeAll$domain_name_caps() = flow {
        emitAll(localDataSource.observeAll$domain_name_caps())
        remoteDataSource.getAll$domain_name_caps().suspendProcessState {
            localDataSource.insert(it)
        }
    }

    suspend fun getAll$domain_name_caps() {
        
    }
}" >  ~/$domain_name/data/"$domain_name_caps"RepositoryImpl.kt

# Writing code for local data source files
printf "package $package_name.$domain_name.data.local

interface "$domain_name_caps"LocalDataSource
" > ~/$domain_name/data/local/"$domain_name_caps"LocalDataSource.kt
printf "package $package_name.$domain_name.data.local

import $package_name.$domain_name.data.local."$domain_name_caps"LocalDataSource
import javax.inject.Inject
import kotlinx.coroutines.CoroutineDispatcher

class "$domain_name_caps"LocalDataSourceImpl @Inject constructor(
    private val dao: "$domain_name_caps"Dao,
    private val dispatcher: CoroutineDispatcher
) : "$domain_name_caps"LocalDataSource {
    fun observeAll$domain_name_caps(): Flow<List<"$domain_name_caps"LocalDto>> {
        return dao.observeAll$domain_name_caps()
    }

    suspend fun getAll$domain_name_caps() = withContext(dispatcher) {
        return@withContext State.safeCall { dao.getAll$domain_name_caps() }
    }

    fun observe"$domain_name_caps"ById(id: Int): Flow<"$domain_name_caps"LocalDto> {
        return dao.observe"$domain_name_caps"ById(id)
    }

    suspend fun get"$domain_name_caps"ById(id: Int): "$domain_name_caps"LocalDto {
        return@withContext State.safeCall { dao.get"$domain_name_caps"ById(id) }
    }

    suspend fun clear() = withContext(dispatcher) {
        return@withContext State.safeCall { dao.clear() }
    }
}" > ~/$domain_name/data/local/"$domain_name_caps"LocalDataSourceImpl.kt
printf "package $package_name.$domain_name.data.local.dao

import "$package_name"."$domain_name".data.local."$domain_name_caps"LocalDto
import androidx.room.Dao
import androidx.room.Query
import kotlinx.coroutines.flow.Flow

@Dao
interface "$domain_name_caps"Dao : BaseDao<"$domain_name_caps"LocalDto> {
    @Query("SELECT * FROM $domain_name_caps")
    fun observeAll$domain_name_caps(): Flow<List<$domain_name_caps>>

    @Query("SELECT * FROM $domain_name_caps")
    suspend fun getAll$domain_name_caps(): List<$domain_name_caps>

    @Query("SELECT * FROM $domain_name_caps WHERE id=:id")
    fun observe"$domain_name_caps"ById(id: Int): Flow<List<$domain_name_caps>>

    @Query("SELECT * FROM $domain_name_caps WHERE id=:id")
    suspend fun get"$domain_name_caps"ById(id: Int): List<$domain_name_caps>

    @Query("DELETE FROM $domain_name_caps")
    suspend fun clear()
}" > ~/$domain_name/data/local/dao/"$domain_name_caps"Dao.kt
printf "package $package_name.$domain_name.data.local.dto

import androidx.room.Entity as LocalDto
import androidx.room.PrimaryKey

@LocalDto
data class "$domain_name_caps"LocalDto(
    @PrimaryKey
    id: Int
)" > ~/$domain_name/data/local/dto/"$domain_name_caps"Dto.kt

# Writing code for remote data source files
printf "package $package_name.$domain_name.data.remote

interface "$domain_name_caps"RemoteDataSource
" > ~/$domain_name/data/remote/"$domain_name_caps"RemoteDataSource.kt
printf "package $package_name.$domain_name.data.remote

import $package_name.$domain_name.data.remote."$domain_name_caps"RemoteDataSource
import javax.inject.Inject

class "$domain_name_caps"RemoteDataSourceImpl @Inject constructor(
    private val api: "$domain_name_caps"Api
) : "$domain_name_caps"RemoteDataSource {

}" > ~/$domain_name/data/remote/"$domain_name_caps"RemoteDataSourceImpl.kt
printf "package $package_name.$domain_name.data.remote.api

interface "$domain_name_caps"Api {
    suspend fun getAll$domain_name_caps() : Call<BaseResponse<GetAll"$domain_name_caps"ResponseDto>>
}
" > ~/$domain_name/data/remote/api/"$domain_name_caps"Api.kt
printf "package $package_name.$domain_name.data.remote.dto
" > ~/$domain_name/data/remote/dto/"$domain_name_caps"Dto.kt

# Writing code for di files
printf "package $package_name.$domain_name.di
" > ~/$domain_name/di/"$domain_name_caps"Module.kt

# Writing code for domain files
printf "package $package_name.$domain_name.domain

data class "$domain_name_caps"Entity
" > ~/$domain_name/domain/"$domain_name_caps"Entity.kt

# Writing code for use case files
printf "package $package_name.$domain_name.domain

import $package_name.$domain_name.data."$domain_name_caps"Repository

data class ObserveAll"$domain_name_caps"UseCase @Inject constructor(
    private val repository: "$domain_name_caps"Repository
) {
    operator fun invoke(): Flow<List<$domain_name_caps>> = repository.observeAll$domain_name_caps()
}" > ~/$domain_name/domain/usecase/ObserveAll"$domain_name_caps"UseCase.kt
printf "package $package_name.$domain_name.domain

import $package_name.$domain_name.data."$domain_name_caps"Repository

data class GetAll"$domain_name_caps"UseCase @Inject constructor(
    private val repository: "$domain_name_caps"Repository
) {
    operator fun suspend invoke(): List<$domain_name_caps> = repository.getAll$domain_name_caps()
}" > ~/$domain_name/domain/usecase/GetAll"$domain_name_caps"UseCase.kt
printf "package $package_name.$domain_name.domain

import $package_name.$domain_name.data."$domain_name_caps"Repository

data class Observe"$domain_name_caps"ByIdUseCase @Inject constructor(
    private val repository: "$domain_name_caps"Repository
) {
    operator fun invoke(id: Int): Flow<$domain_name_caps> = repository.observe"$domain_name_caps"ById(id)
}" > ~/$domain_name/domain/usecase/Observe"$domain_name_caps"ByIdUseCase.kt
printf "package $package_name.$domain_name.domain

import $package_name.$domain_name.data."$domain_name_caps"Repository

data class Get"$domain_name_caps"ByIdUseCase @Inject constructor(
    private val repository: "$domain_name_caps"Repository
) {
    operator fun invoke(id: Int): $domain_name_caps? = repository.get"$domain_name_caps"ById(id)
}" > ~/$domain_name/domain/usecase/Get"$domain_name_caps"ByIdUseCase.kt
printf "package $package_name.$domain_name.domain.usecase

import $package_name.$domain_name.data."$domain_name_caps"Repository

data class Clear"$domain_name_caps"UseCase @Inject constructor(
    private val repository: "$domain_name_caps"Repository
) {
    operator fun invoke() = repository.clear()
}
" > ~/$domain_name/domain/usecase/Clear"$domain_name_caps"UseCase.kt

# Writing code for ui files
printf "package $package_name.$domain_name.ui.uistate

" > ~/$domain_name/ui/uistate/"$domain_name_caps"ScreenUiState.kt
printf "package $package_name.$domain_name.ui

import androidx.compose.runtime.Composable

@Composable
fun "$domain_name_caps"Screen() {

}" > ~/$domain_name/ui/"$domain_name_caps"Composables.kt
printf "package $package_name.$domain_name.ui.viewmodel

import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

@HiltViewModel
class "$domain_name_caps"ViewModel @Inject constructor(

) : BaseViewModel() {

}" > ~/$domain_name/ui/viewmodel/"$domain_name_caps"ViewModel.kt
#endregion