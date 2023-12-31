﻿using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace TECAirAPI.Models;

/* The `Stop` class represents a stop in a flight itinerary, with properties such as stop ID, departure and arrival airports, date and time, flight number, and a collection of associated users. */
public partial class Stop
{
    public int Stopid { get; set; }

    public int Sfrom { get; set; }

    public int Sto { get; set; }

    public DateOnly Sdate { get; set; }

    public TimeOnly DepartureHour { get; set; }

    public TimeOnly ArrivalHour { get; set; }

    public int Fno { get; set; }
    [JsonIgnore]
    public virtual Flight FnoNavigation { get; set; } = null!;
    [JsonIgnore]
    public virtual Airport SfromNavigation { get; set; } = null!;
    [JsonIgnore]
    public virtual Airport StoNavigation { get; set; } = null!;
    [JsonIgnore]
    public virtual ICollection<Userw> Uemails { get; set; } = new List<Userw>();
}
