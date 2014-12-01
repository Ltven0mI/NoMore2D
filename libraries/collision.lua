collision = {}

function collision.boundingBox(x1,y1,w1,h1,vx1,vy1,x2,y2,w2,h2)
	if x1 and y1 and w1 and h1 and vx1 and vy1 and x2 and y2 and w2 and h2 then
		local u1, d1, l1, r1 = y1, y1+h1, x1, x1+w1
		local u2, d2, l2, r2 = y2, y2+h2, x2, x2+w2
		local hx, hy = x1, y1
		local side = ""

		hx = hx-vx1
		u1, d1, l1, r1 = hy, hy+h1, hx, hx+w1

		if vy1 < 0 then
			if (d1>u2 and d1<=d2 and u1<u2) or (u1<d2 and u1>=u2 and d1>d2) or (u1<u2 and d1>d2) or (u1>=u2 and u1<d2 and d1<=d2 and d1>u2) then --Colliding on the top
				if (r1>l2 and r1<=r2 and l1<l2) or (l1<r2 and l1>=l2 and r1>r2) or (l1<l2 and r1>r2) or (l1>=l2 and l1<r2 and r1<=r2 and r1>l2) then --Checks if there is any collision on the y plane
					vy1 = 0
					hy = y2+h2
					side = "up"
				end
			end
		end
		if vy1 > 0 then
			if (d1>u2 and d1<=d2 and u1<u2) or (u1<d2 and u1>=u2 and d1>d2) or (u1<u2 and d1>d2) or (u1>=u2 and u1<d2 and d1<=d2 and d1>u2) then --Colliding on the bottom
				if (r1>l2 and r1<=r2 and l1<l2) or (l1<r2 and l1>=l2 and r1>r2) or (l1<l2 and r1>r2) or (l1>=l2 and l1<r2 and r1<=r2 and r1>l2) then --Checks if there is any collision on the y plane
					vy1 = 0
					hy = y2-h1
					side = "down"
				end
			end
		end

		hx = hx+vx1
		hy = hy-vy1
		u1, d1, l1, r1 = hy, hy+h1, hx, hx+w1

		if vx1 < 0 then
			if (r1>l2 and r1<=r2 and l1<l2) or (l1<r2 and l1>=l2 and r1>r2) or (l1<l2 and r1>r2) or (l1>=l2 and l1<r2 and r1<=r2 and r1>l2) then --Colliding on the left
				if (d1>u2 and d1<=d2 and u1<u2) or (u1<d2 and u1>=u2 and d1>d2) or (u1<u2 and d1>d2) or (u1>=u2 and u1<d2 and d1<=d2 and d1>u2) then --Checks if there is any collision on the x plane
					vx1 = 0
					hx = x2+w2
					side = "left"
				end
			end
		end
		if vx1 > 0 then
			if (r1>l2 and r1<=r2 and l1<l2) or (l1<r2 and l1>=l2 and r1>r2) or (l1<l2 and r1>r2) or (l1>=l2 and l1<r2 and r1<=r2 and r1>l2) then --Colliding on the right
				if (d1>u2 and d1<=d2 and u1<u2) or (u1<d2 and u1>=u2 and d1>d2) or (u1<u2 and d1>d2) or (u1>=u2 and u1<d2 and d1<=d2 and d1>u2) then --Checks if there is any collision on the x plane
					vx1 = 0
					hx = x2-w1
					side = "right"
				end
			end
		end
		hy = hy+vy1
		return hx, hy, vx1, vy1, side
	else
		debug.log("[ERROR] Incorrect call to function 'collision.boundingBox(x1,y1,w1,h1,vx1,vy1,x2,y2,w2,h2)'")
		return 0, 0, 0, 0
	end
end

function collision.boundingCircle(x1,y1,r1,vx1,vy1,x2,y2,r2)
	if x1 and y1 and r1 and vx1 and vy1 and x2 and y2 and r2 then
		local dist = nil
		x1, y1 = x1+r1, y1+r1
		x2, y2 = x2+r2, y2+r2

		--Check Y
		dist = math.dist(x1,y1+vy1,x2,y2)
		if dist>r1+r2 then
			y1 = y1+vy1
		else
			--x1, y1 = math.cos(math.rad(ang))*(r1+r2)+x2, math.sin(math.rad(ang))*(r1+r2)+y2
			vy1 = 0
		end
		--Check X
		dist = math.dist(x1+vx1,y1,x2,y2)
		if dist>r1+r2 then
			x1 = x1+vx1
		else
			--x1, y1 = math.cos(math.rad(ang))*(r1+r2)+x2, math.sin(math.rad(ang))*(r1+r2)+y2
			vx1 = 0
		end

		x1, y1 = x1-r1, y1-r1
		x2, y2 = x2-r2, y2-r2

		return x1, y1, vx1, vy1
	else
		debug.log("[ERROR] Incorrect call to function 'collision.boundingCircle(x1,y1,r1,vx1,vy1,x2,y2,r2)'")
	end
end

return collision