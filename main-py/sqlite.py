# -*- coding: utf-8 -*-
# Created by lewislin at 11/14/18

import os
import sqlite3


class SqliteClient:

    def __init__(self,
                 db_name):
        """
        init the sqlite file and connect.
        :param db_name: setting the sqlite file name.
        """

        # generating the sqlite file path
        _sqlite_path = os.path.join(os.getcwd(),
                                    'database/sqlite')
        _sqlite = os.path.join(_sqlite_path,
                               '{}.sqlite'.format(db_name))

        # check the sqlite dir exist or not. if not exist, make a dir to save sqlite file.
        if not os.path.exists(_sqlite_path):
            os.makedirs(_sqlite_path)

        # sqlite connect
        self._conn = sqlite3.connect(_sqlite)
        self._cursor = self._conn.cursor()

    def select(self,
               query: str,
               parameters: tuple,
               ):
        """
        'SELECT' data from database in sqlite file.
        :param query: SQL query syntax
        :param parameters: parameters
        :return: query result
        """
        try:
            self._cursor.execute(sql=query,
                                 parameters=parameters)
            return self._cursor.fetchall()

        except Exception as error:
            print(error)
            self._conn.rollback()

        finally:
            if self._cursor:
                self._cursor.close()
            if self._conn:
                self._conn.close()

    def insert(self,
               statement: str,
               parameters: tuple,
               ):
        """
        'INSERT' single data 'INTO' database in sqlite file.
        :param statement: SQL query syntax
        :param parameters: parameters
        :return: None
        """

        try:
            self._cursor.execute(sql=statement,
                                 parameters=parameters)
            self._conn.commit()

        except Exception as error:
            print(error)
            self._conn.rollback()

        finally:
            if self._cursor:
                self._cursor.close()
            if self._conn:
                self._conn.close()

    def insert_many(self,
                    statement: str,
                    parameters: tuple,
                    ):
        """
        'INSERT' multiple data 'INTO' database in sqlite file.
        :param statement: SQL query syntax
        :param parameters: parameters
        :return: None
        """

        try:
            self._cursor.executemany(sql=statement,
                                     seq_of_parameters=parameters)
            self._conn.commit()

        except Exception as error:
            print(error)
            self._conn.rollback()

        finally:
            if self._cursor:
                self._cursor.close()
            if self._conn:
                self._conn.close()
