﻿using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Npgsql;
using System.Data;
using TECAirAPI.Dtos;
using TECAirAPI.Models;
using TECAirAPI.Functions;

namespace TECAirAPI.Controllers
{
    [Route("api/")]
    [ApiController]
    public class StopController : ControllerBase
    {
        SQLfn sqlfn = new SQLfn();
        private readonly TecairContext _context;
        private readonly IConfiguration _configuration;

        public StopController(TecairContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
        }

        /// <summary>
        /// This C# function retrieves data from a database table called "STOP" and returns it as a JSON result.
        /// </summary>
        /// <returns>
        /// The method is returning a JsonResult object, which contains the data from the "STOP" table in the TECAir database.
        /// </returns>
        [HttpGet]
        [Route("stop")]
        public JsonResult Get()
        {
            string query = @"
                 SELECT stopid, sfrom, sto, to_char(sdate, 'YYYY-MM-DD') AS sdate, departure_hour, arrival_hour, fno
	             FROM STOP;
            ";

            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("TECAir");
            NpgsqlDataReader myReader;
            using (NpgsqlConnection myCon = new NpgsqlConnection(sqlDataSource))
            {
                myCon.Open();
                using (NpgsqlCommand myCommand = new NpgsqlCommand(query, myCon))
                {
                    myReader = myCommand.ExecuteReader();
                    table.Load(myReader);

                    myReader.Close();
                    myCon.Close();
                }
            }

            return new JsonResult(table);
        }

        /// <summary>
        /// The above function is an HTTP GET endpoint that retrieves available stops from a database and returns them as a JSON result.
        /// </summary>
        /// <returns>
        /// The method is returning a JsonResult object, which contains the data from the "table" DataTable.
        /// </returns>
        [HttpGet]
        [Route("stop/available")]
        public JsonResult GetStops()
        {
            string query = sqlfn.AvailableS();

            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("TECAir");
            NpgsqlDataReader myReader;
            using (NpgsqlConnection myCon = new NpgsqlConnection(sqlDataSource))
            {
                myCon.Open();
                using (NpgsqlCommand myCommand = new NpgsqlCommand(query, myCon))
                {
                    myReader = myCommand.ExecuteReader();
                    table.Load(myReader);

                    myReader.Close();
                    myCon.Close();
                }
            }

            return new JsonResult(table);
        }

       /// <summary>
       /// This C# function updates a stop record in a database and returns the updated stop information as a JSON result.
       /// </summary>
       /// <param name="StopDto">StopDto is a data transfer object that represents a stop in a flight itinerary. It contains the following properties:</param>
       /// <returns>
       /// The method is returning a JsonResult object.
       /// </returns>
        [HttpPut]
        [Route("stop/modify")]
        public async Task<JsonResult> Put(StopDto stop)
        {
            string query = @"
                 UPDATE STOP
	             SET sfrom=@sfrom, sto=@sto, sdate=@sdate, departure_hour=@departure_hour, arrival_hour=@arrival_hour
	             WHERE stopid=@stopid;

                 SELECT stopid, sfrom, sto, to_char(sdate, 'YYYY-MM-DD') AS sdate, departure_hour, arrival_hour, fno
	             FROM STOP;
            ";

            var layover = await _context.Stops.FindAsync(stop.Stopid);

            if (layover == null)
                return new JsonResult("Escala no encontrada");

            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("TECAir");
            NpgsqlDataReader myReader;
            using (NpgsqlConnection myCon = new NpgsqlConnection(sqlDataSource))
            {
                myCon.Open();
                using (NpgsqlCommand myCommand = new NpgsqlCommand(query, myCon))
                {
                    myCommand.Parameters.AddWithValue("@stopid", stop.Stopid);
                    myCommand.Parameters.AddWithValue("@sfrom", stop.Sfrom);
                    myCommand.Parameters.AddWithValue("@sto", stop.Sto);
                    myCommand.Parameters.AddWithValue("@departure_hour", stop.DepartureHour);
                    myCommand.Parameters.AddWithValue("@arrival_hour", stop.ArrivalHour);
                    myCommand.Parameters.AddWithValue("@sdate", stop.Sdate);
                    myReader = myCommand.ExecuteReader();
                    table.Load(myReader);

                    myReader.Close();
                    myCon.Close();
                }
            }

            return new JsonResult(table);
        }

      /// <summary>
      /// The above function is a C# code snippet that handles a HTTP POST request to create a new stop in a database and returns the updated list of stops.
      /// </summary>
      /// <param name="StopDto">StopDto is a data transfer object that contains the following properties:</param>
      /// <returns>
      /// The method is returning a JsonResult object.
      /// </returns>
        [HttpPost]
        [Route("stop/new")]
        public async Task<JsonResult> Post(StopDto stop)
        {
            string query = @"
                 INSERT INTO STOP(
	                    sfrom, sto, sdate, departure_hour, arrival_hour, fno)
	             VALUES (@sfrom, @sto, @sdate, @departure_hour, @arrival_hour, @fno);

                 SELECT stopid, sfrom, sto, to_char(sdate, 'YYYY-MM-DD') AS sdate, departure_hour, arrival_hour, fno
	             FROM STOP;
            ";

            var from = await _context.Airports.FindAsync(stop.Sfrom);
            var to = await _context.Airports.FindAsync(stop.Sto);
            var plane = await _context.Flights.FindAsync(stop.Fno);

            if (from == null)
                return new JsonResult("Origen no encontrado");
            if (to == null)
                return new JsonResult("Destino no encontrado");
            if (plane == null)
                return new JsonResult("Vuelo no encontrado");

            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("TECAir");
            NpgsqlDataReader myReader;
            using (NpgsqlConnection myCon = new NpgsqlConnection(sqlDataSource))
            {
                myCon.Open();
                using (NpgsqlCommand myCommand = new NpgsqlCommand(query, myCon))
                {
                    myCommand.Parameters.AddWithValue("@sfrom", stop.Sfrom);
                    myCommand.Parameters.AddWithValue("@sto", stop.Sto);
                    myCommand.Parameters.AddWithValue("@sdate", stop.Sdate);
                    myCommand.Parameters.AddWithValue("@departure_hour", stop.DepartureHour);
                    myCommand.Parameters.AddWithValue("@arrival_hour", stop.ArrivalHour);
                    myCommand.Parameters.AddWithValue("@fno", stop.Fno);
                    myReader = myCommand.ExecuteReader();
                    table.Load(myReader);

                    myReader.Close();
                    myCon.Close();
                }
            }

            return new JsonResult(table);
        }

        [HttpDelete]
        [Route("stop/delete")]
        public async Task<JsonResult> Delete(StopDto id)
        {
            string query = @"
                 DELETE FROM STOP
	             WHERE stopid=@stopid;

                 SELECT stopid, sfrom, sto, to_char(sdate, 'YYYY-MM-DD') AS sdate, departure_hour, arrival_hour, fno
	             FROM STOP;
            ";

            var flight = await _context.Flights.FindAsync(id);

            if (flight == null)
                return new JsonResult("Escala no encontradA");

            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("TECAir");
            NpgsqlDataReader myReader;
            using (NpgsqlConnection myCon = new NpgsqlConnection(sqlDataSource))
            {
                myCon.Open();
                using (NpgsqlCommand myCommand = new NpgsqlCommand(query, myCon))
                {
                    myCommand.Parameters.AddWithValue("@stopid", id);
                    myReader = myCommand.ExecuteReader();
                    table.Load(myReader);

                    myReader.Close();
                    myCon.Close();
                }
            }

            return new JsonResult(table);
        }
    }
}
